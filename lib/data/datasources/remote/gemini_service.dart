import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_chat_app/domain/models/message.dart';
import 'package:flutter_chat_app/domain/models/model_config.dart';
import 'package:flutter_chat_app/domain/models/token_usage.dart';
import 'package:flutter_chat_app/domain/models/message_image.dart';
import 'package:flutter_chat_app/domain/enums/role.dart' as app_role;
import 'dart:convert';

/// Gemini APIサービス
class GeminiService {
  ChatSession? _chat;
  ModelConfig? _config;
  GenerativeModel? _model;

  /// 設定を更新
  void updateConfig(ModelConfig config) {
    _config = config;
    _initializeModel();
    _chat = null; // 設定変更時にチャットをリセット
  }

  /// モデルを初期化
  void _initializeModel() {
    if (_config == null) return;
    
    final apiKey = _config!.apiKey ?? const String.fromEnvironment('GEMINI_API_KEY');
    
    if (apiKey.isEmpty) {
      print('警告: Gemini API キーが設定されていません');
      return;
    }

    _model = GenerativeModel(
      model: _config!.modelId,
      apiKey: apiKey,
      systemInstruction: Content.system(_config!.systemInstruction),
      generationConfig: GenerationConfig(
        temperature: _config!.temperature,
        topP: _config!.topP,
        topK: _config!.topK,
      ),
    );
  }

  /// チャット履歴を使ってセッションを開始
  void startChat(List<Message> history) {
    if (_model == null) {
      print('警告: Gemini モデルが初期化されていません');
      return;
    }

    final formattedHistory = history.map((msg) {
      // Watson (Observer) をユーザーとメインAIから区別
      if (msg.role == app_role.Role.watson) {
        return Content.text('[Advisor Watson]: ${msg.text}');
      }

      final parts = <Part>[TextPart(msg.text)];

      // 履歴から画像を再読み込み
      if (msg.images != null && msg.images!.isNotEmpty) {
        for (final img in msg.images!) {
          parts.add(DataPart(img.mimeType,  base64.decode(img.base64)));
        }
      }

      return Content(
        msg.role == app_role.Role.user ? 'user' : 'model',
        parts,
      );
    }).toList();

    _chat = _model!.startChat(history: formattedHistory);
  }

  /// メッセージをストリームで送信
  Stream<String> sendMessageStream(
    String message,
    void Function(TokenUsage)? onUsage,
    List<MessageImage>? images,
  ) async* {
    if (_model == null) {
      throw Exception('Gemini APIキーがありません');
    }

    if (_chat == null) {
      startChat([]);
    }

    if (_chat == null) {
      throw Exception('チャット初期化に失敗しました');
    }

    try {
      // パーツを構築: テキスト + 画像
      final parts = <Part>[TextPart(message)];

      if (images != null && images.isNotEmpty) {
        for (final img in images) {
          parts.add(DataPart(img.mimeType, base64.decode(img.base64)));
        }
      }

      final content = Content.text(message);
      final stream = _chat!.sendMessageStream(content);

      await for (final chunk in stream) {
        // 使用量メタデータをチェック
        if (chunk.usageMetadata != null && onUsage != null) {
          final metadata = chunk.usageMetadata!;
          onUsage(TokenUsage(
            promptTokens: metadata.promptTokenCount ?? 0,
            completionTokens: metadata.candidatesTokenCount ?? 0,
            totalTokens: metadata.totalTokenCount ?? 0,
          ));
        }

        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
    } catch (error) {
      print('Gemini APIエラー: $error');
      rethrow;
    }
  }
}
