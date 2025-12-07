import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_app/core/theme/app_colors.dart';
import 'package:flutter_chat_app/presentation/providers/chat_provider.dart';
import 'package:flutter_chat_app/presentation/providers/sessions_provider.dart';
import 'package:flutter_chat_app/presentation/providers/settings_provider.dart';
import 'package:flutter_chat_app/presentation/widgets/sidebar/sidebar.dart';
import 'package:flutter_chat_app/presentation/widgets/chat/chat_message.dart';
import 'package:flutter_chat_app/presentation/widgets/chat/chat_input.dart';
import 'package:flutter_chat_app/presentation/widgets/common/model_selector.dart';
import 'package:flutter_chat_app/presentation/dialogs/settings_dialog.dart';
import 'package:flutter_chat_app/core/utils/id_generator.dart';
import 'package:flutter_chat_app/domain/models/chat_session.dart';
import 'package:flutter_chat_app/domain/models/project.dart';
import 'package:flutter_chat_app/domain/enums/role.dart';
import 'package:flutter_chat_app/domain/enums/thinking_level.dart';

/// チャット画面（メインスクリーン）
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  bool _isSidebarOpen = false;
  bool _isSettingsOpen = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    // 初期化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // デスクトップの場合はサイドバーを開く
      final width = MediaQuery.of(context).size.width;
      if (width >= 1024) {
        setState(() {
          _isSidebarOpen = true;
        });
      }

      // 初期セッションを作成
      _initializeFirstSession();
    });
  }

  void _initializeFirstSession() {
    final sessionsAsync = ref.read(sessionsProvider);
    sessionsAsync.whenData((sessions) {
      if (sessions.isEmpty) {
        // 初回起動時に新規セッションを作成
        final newSessionId = IdGenerator.generate();
        final newSession = ChatSession(
          id: newSessionId,
          title: '新規チャット',
          messages: const [],
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        );
        ref.read(sessionsProvider.notifier).saveSession(newSession);
        ref.read(currentSessionIdProvider.notifier).state = newSessionId;
      } else {
        // 最新のセッションを選択
        ref.read(currentSessionIdProvider.notifier).state = sessions.first.id;
        // メッセージをロード
        ref.read(chatProvider.notifier).loadMessages(sessions.first.messages);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final currentSession = ref.watch(currentSessionProvider);

    // メッセージが追加されたらスクロール
    ref.listen(chatProvider, (previous, next) {
      if (next.messages.length > (previous?.messages.length ?? 0)) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    // セッション変更時にメッセージをロード
    ref.listen(currentSessionProvider, (previous, next) {
      if (next != null && next.id != previous?.id) {
        ref.read(chatProvider.notifier).loadMessages(next.messages);
      }
    });

    return Scaffold(
      body: Row(
        children: [
          // サイドバー
          if (_isSidebarOpen)
            Sidebar(
              isOpen: _isSidebarOpen,
              onClose: () {
                setState(() {
                  _isSidebarOpen = false;
                });
              },
              onOpenSettings: () {
                showDialog(
                  context: context,
                  builder: (context) => const SettingsDialog(),
                );
              },
              onOpenProjects: () {
                // TODO: ProjectManagerを開く
              },
            ),

          // メインコンテンツ
          Expanded(
            child: Column(
              children: [
                // ヘッダー
                _buildHeader(settingsAsync.asData?.value.projects),

                // チャットエリア
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: chatState.messages.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(bottom: 100),
                            itemCount: chatState.messages.length,
                            itemBuilder: (context, index) {
                              final message = chatState.messages[index];
                              return ChatMessage(
                                message: message,
                                onToggleContext: message.role == Role.watson
                                    ? () => ref
                                        .read(chatProvider.notifier)
                                        .toggleMessageContext(message.id)
                                    : null,
                              );
                            },
                          ),
                  ),
                ),

                // ローディングインジケーター
                if (chatState.isLoading || chatState.isWatsonTyping)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          chatState.isWatsonTyping
                              ? 'Watsonが考えています...'
                              : 'AIが考えています...',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                // 入力エリア
                settingsAsync.when(
                  data: (settings) => ChatInput(
                    onSend: ({
                      required text,
                      images,
                      webSearch = false,
                      deepResearch = false,
                      thinkingLevel = ThinkingLevel.off,
                      watsonEnabled = false,
                    }) {
                      ref.read(chatProvider.notifier).sendMessage(
                            text: text,
                            images: images,
                            webSearch: webSearch,
                            deepResearch: deepResearch,
                            thinkingLevel: thinkingLevel,
                            watsonEnabled: watsonEnabled,
                          );
                    },
                    isLoading: chatState.isLoading || chatState.isWatsonTyping,
                    searchEnabled: settings.search.enabled,
                  ),
                  loading: () => const SizedBox(height: 100),
                  error: (_, __) => const SizedBox(height: 100),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(List<Project>? projects) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: AppColors.surfaceAlt,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // サイドバートグルボタン
            if (!_isSidebarOpen)
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  setState(() {
                    _isSidebarOpen = true;
                  });
                },
                tooltip: 'サイドバーを開く',
              ),

            // タイトル
            const Text(
              'Multi GenAI Chat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(),

            // モデルセレクター
            ModelSelector(
              onManageModels: () {
                setState(() {
                  _isSettingsOpen = true;
                });
              },
            ),

            const SizedBox(width: 8),

            // ダウンロードボタン
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                // TODO: エクスポート機能
              },
              tooltip: 'チャットをダウンロード',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 32,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Multi GenAI Chatへようこそ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'GeminiとマルチプロバイダーLLMで動作するインテリジェントワークスペース',
            style: TextStyle(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
