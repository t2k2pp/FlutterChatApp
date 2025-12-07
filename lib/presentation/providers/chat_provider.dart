import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_app/domain/models/message.dart';
import 'package:flutter_chat_app/domain/models/message_image.dart';
import 'package:flutter_chat_app/domain/models/reasoning_step.dart';
import 'package:flutter_chat_app/domain/enums/role.dart';
import 'package:flutter_chat_app/domain/enums/thinking_level.dart';
import 'package:flutter_chat_app/core/utils/id_generator.dart';
import 'package:flutter_chat_app/core/utils/session_utils.dart';
import 'package:flutter_chat_app/presentation/providers/sessions_provider.dart';
import 'package:flutter_chat_app/presentation/providers/settings_provider.dart';
import 'package:flutter_chat_app/data/datasources/remote/gemini_service.dart';
import 'package:flutter_chat_app/data/datasources/remote/openai_service.dart';
import 'package:flutter_chat_app/data/datasources/remote/searxng_service.dart';
import 'package:flutter_chat_app/data/services/response_parser.dart';
import 'package:flutter_chat_app/data/services/watson_service.dart';
import 'package:flutter_chat_app/data/services/thinking_agent.dart';
import 'package:flutter_chat_app/data/services/research_agent.dart';
import 'package:flutter_chat_app/data/services/time_awareness_service.dart';
import 'package:flutter_chat_app/domain/enums/ai_provider.dart';

/// Chat State
class ChatState {
  final List<Message> messages;
  final bool isLoading;
  final bool isWatsonTyping;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.isWatsonTyping = false,
    this.error,
  });

  ChatState copyWith({
    List<Message>? messages,
    bool? isLoading,
    bool? isWatsonTyping,
    String? error,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isWatsonTyping: isWatsonTyping ?? this.isWatsonTyping,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Chat Provider
class ChatNotifier extends StateNotifier<ChatState> {
  final Ref _ref;

  ChatNotifier(this._ref) : super(const ChatState());

  /// メッセージを送信
  Future<void> sendMessage({
    required String text,
    List<MessageImage>? images,
    bool webSearch = false,
    bool deepResearch = false,
    ThinkingLevel thinkingLevel = ThinkingLevel.off,
    bool watsonEnabled = false,
  }) async {
    if (text.trim().isEmpty) return;

    final settingsAsync = _ref.read(settingsProvider);
    final settings = settingsAsync.asData?.value;
    if (settings == null) return;

    final sessionId = _ref.read(currentSessionIdProvider);
    if (sessionId == null) return;

    // ユーザーメッセージを追加
    final userMessage = Message(
      id: IdGenerator.generate(),
      role: Role.user,
      text: text,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      images: images,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      clearError: true,
    );

    try {
      // コンテキストを準備
      String extraContext = '';

      // 時間認識
      if (settings.timeAwareness && TimeAwarenessService.shouldInjectTime(text)) {
        extraContext += '\n[システムノート: 現在の日時は ${TimeAwarenessService.getCurrentDateTime()}]\n';
      }

      // プロジェクトコンテキスト
      // TODO: activeProjectIdから取得

      // Web検索
      if (webSearch && settings.search.enabled) {
        try {
          if (deepResearch) {
            // Deep Research
            final researchAgent = ResearchAgent((logs) {
              // 推論ログ更新
            });
            final activeModel = settings.models.firstWhere(
              (m) => m.id == settings.activeModelId,
              orElse: () => settings.models.first,
            );
            final result = await researchAgent.executeDeepResearch(
              text,
              settings.search,
              state.messages,
              activeModel,
            );
            extraContext += '\n[Deep Research Results]:\n$result\n';
          } else {
            // 通常の検索
            final results = await SearchService.search(text, settings.search.baseUrl);
            final formatted = results
                .map((r) => '* [${r.title}](${r.url}): ${r.content}')
                .join('\n');
            extraContext += '\n[Web Search Results]:\n$formatted\n';
          }
        } catch (e) {
          // 検索エラーは無視して続行
        }
      }

      // Thinking Agent
      String finalInput = text;
      if (thinkingLevel != ThinkingLevel.off) {
        final activeModel = settings.models.firstWhere(
          (m) => m.id == settings.activeModelId,
          orElse: () => settings.models.first,
        );
        final thinkingAgent = ThinkingAgent((logs) {
          // 推論ログ更新
        });
        finalInput = await thinkingAgent.executeThinking(
          text,
          thinkingLevel,
          extraContext,
          activeModel,
        );
      } else {
        finalInput = '$extraContext\n\n$text';
      }

      // メインAI生成
      final aiMessageId = IdGenerator.generate();
      final aiMessage = Message(
        id: aiMessageId,
        role: Role.model,
        text: '',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
      );

      // AIサービスを取得
      final activeModel = settings.models.firstWhere(
        (m) => m.id == settings.activeModelId,
        orElse: () => settings.models.first,
      );

      dynamic service;
      if (activeModel.provider == AIProvider.gemini) {
        service = GeminiService();
      } else {
        service = OpenAIService();
      }

      service.updateConfig(activeModel);
      service.startChat(state.messages.where((m) => m.id != aiMessageId).toList());

      // ストリーミング
      final parser = ResponseParser();
      String aiText = '';
      String aiThoughts = '';

      final stream = service.sendMessageStream(finalInput, null, images);

      await for (final chunk in stream) {
        final parsed = parser.parse(chunk);
        aiText += parsed['contentDelta'] ?? '';
        aiThoughts += parsed['thoughtDelta'] ?? '';

        // UIを更新
        state = state.copyWith(
          messages: state.messages.map((m) {
            if (m.id == aiMessageId) {
              return m.copyWith(
                text: aiText,
                reasoningLogs: aiThoughts.isNotEmpty
                    ? [
                        ReasoningStep(
                          type: ReasoningType.thought,
                          content: aiThoughts,
                          timestamp: DateTime.now().millisecondsSinceEpoch,
                        )
                      ]
                    : null,
              );
            }
            return m;
          }).toList(),
        );
      }

      final flushed = parser.flush();
      aiText += flushed['contentDelta'] ?? '';
      aiThoughts += flushed['thoughtDelta'] ?? '';

      // 最終更新
      final finalAiMessage = aiMessage.copyWith(
        text: aiText,
        reasoningLogs: aiThoughts.isNotEmpty
            ? [
                ReasoningStep(
                  type: ReasoningType.thought,
                  content: aiThoughts,
                  timestamp: DateTime.now().millisecondsSinceEpoch,
                )
              ]
            : null,
      );

      state = state.copyWith(
        messages: state.messages.map((m) {
          return m.id == aiMessageId ? finalAiMessage : m;
        }).toList(),
        isLoading: false,
      );

      // Watson Observer
      if (watsonEnabled && !WatsonService.isAddressingWatson(text)) {
        state = state.copyWith(isWatsonTyping: true);

        final intervention = await WatsonService.observeAndIntervene(
          text,
          aiText,
          settings,
        );

        state = state.copyWith(isWatsonTyping: false);

        if (intervention != null) {
          final watsonMessage = Message(
            id: IdGenerator.generate(),
            role: Role.watson,
            text: intervention.text,
            timestamp: DateTime.now().millisecondsSinceEpoch,
            reasoningLogs: intervention.thoughts.isNotEmpty
                ? [
                    ReasoningStep(
                      type: ReasoningType.thought,
                      content: intervention.thoughts,
                      timestamp: DateTime.now().millisecondsSinceEpoch,
                    )
                  ]
                : null,
            includedInContext: false,
          );

          state = state.copyWith(
            messages: [...state.messages, watsonMessage],
          );
        } else {
          // Watson承認済みマーク
          state = state.copyWith(
            messages: state.messages.map((m) {
              return m.id == aiMessageId ? m.copyWith(watsonChecked: true) : m;
            }).toList(),
          );
        }
      }

      // セッションを保存
      await _saveCurrentSession();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isWatsonTyping: false,
        error: e.toString(),
      );
    }
  }

  /// メッセージをロード
  void loadMessages(List<Message> messages) {
    state = state.copyWith(messages: messages);
  }

  /// メッセージのコンテキスト含有をトグル
  Future<void> toggleMessageContext(String messageId) async {
    state = state.copyWith(
      messages: state.messages.map((m) {
        if (m.id == messageId) {
          return m.copyWith(includedInContext: !m.includedInContext);
        }
        return m;
      }).toList(),
    );

    await _saveCurrentSession();
  }

  /// セッションを保存
  Future<void> _saveCurrentSession() async {
    final sessionId = _ref.read(currentSessionIdProvider);
    if (sessionId == null) return;

    final currentSession = _ref.read(currentSessionProvider);
    if (currentSession == null) return;

    // タイトルがデフォルトの場合、最初のユーザーメッセージからタイトルを生成
    String title = currentSession.title;
    if (title == '新規チャット' && state.messages.isNotEmpty) {
      final firstUserMessage = state.messages.firstWhere(
        (m) => m.role == Role.user,
        orElse: () => state.messages.first,
      );
      title = SessionUtils.generateTitle(firstUserMessage.text);
    }

    final updatedSession = currentSession.copyWith(
      title: title,
      messages: state.messages,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _ref.read(sessionsProvider.notifier).saveSession(updatedSession);
  }
}

/// Chat Provider
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref);
});
