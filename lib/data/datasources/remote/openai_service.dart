import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_chat_app/domain/models/message.dart';
import 'package:flutter_chat_app/domain/models/model_config.dart';
import 'package:flutter_chat_app/domain/models/token_usage.dart';
import 'package:flutter_chat_app/domain/models/message_image.dart';
import 'package:flutter_chat_app/domain/enums/role.dart' as app_role;

/// OpenAI互換APIサービス（Ollama、LMStudio、LocalAI等）
class OpenAIService {
  ModelConfig? _config;
  List<Map<String, dynamic>> _history = [];
  final http.Client _client = http.Client();

  /// 設定を更新
  void updateConfig(ModelConfig config) {
    _config = config;
    _history = [];
  }

  /// チャット履歴を使ってセッションを開始
  void startChat(List<Message> history) {
    _history = history.map((msg) {
      // Watson (Observer) をユーザーとメインAIから区別
      if (msg.role == app_role.Role.watson) {
        return {
          'role': 'user',
          'content': '[Advisor Watson]: ${msg.text}',
        };
      }

      // 画像サポート（OpenAI形式）
      if (msg.images != null && msg.images!.isNotEmpty) {
        final content = <Map<String, dynamic>>[
          {'type': 'text', 'text': msg.text},
        ];

        for (final img in msg.images!) {
          content.add({
            'type': 'image_url',
            'image_url': {
              'url': 'data:${img.mimeType};base64,${img.base64}',
            },
          });
        }

        return {
          'role': msg.role == app_role.Role.user ? 'user' : 'assistant',
          'content': content,
        };
      }

      return {
        'role': msg.role == app_role.Role.user ? 'user' : 'assistant',
        'content': msg.text,
      };
    }).toList();
  }

  /// メッセージをストリームで送信
  Stream<String> sendMessageStream(
    String message,
    void Function(TokenUsage)? onUsage,
    List<MessageImage>? images,
  ) async* {
    if (_config == null) {
      throw Exception('OpenAI設定がありません');
    }

    final apiKey = _config!.apiKey ?? '';
    final endpoint = _config!.endpoint ?? 'https://api.openai.com/v1';
    final url = '$endpoint/chat/completions';

    // メッセージコンテンツを構築
    dynamic content;
    if (images != null && images.isNotEmpty) {
      final parts = <Map<String, dynamic>>[
        {'type': 'text', 'text': message},
      ];

      for (final img in images) {
        parts.add({
          'type': 'image_url',
          'image_url': {
            'url': 'data:${img.mimeType};base64,${img.base64}',
          },
        });
      }

      content = parts;
    } else {
      content = message;
    }

    final currentMessage = {
      'role': 'user',
      'content': content,
    };

    final messages = [
      if (_config!.systemInstruction.isNotEmpty)
        {'role': 'system', 'content': _config!.systemInstruction},
      ..._history,
      currentMessage,
    ];

    final body = {
      'model': _config!.modelId,
      'messages': messages,
      'stream': true,
      'temperature': _config!.temperature,
      'top_p': _config!.topP,
    };

    // Azure OpenAIの場合、異なるヘッダーとURL形式
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (_config!.deployment != null) {
      // Azure OpenAI
      headers['api-key'] = apiKey;
    } else {
      // 標準OpenAI / 互換API
      if (apiKey.isNotEmpty) {
        headers['Authorization'] = 'Bearer $apiKey';
      }
    }

    try {
      final request = http.Request('POST', Uri.parse(url));
      request.headers.addAll(headers);
      request.body = jsonEncode(body);

      final streamedResponse = await _client.send(request);

      if (streamedResponse.statusCode != 200) {
        final errorBody = await streamedResponse.stream.bytesToString();
        throw Exception('OpenAI APIエラー: ${streamedResponse.statusCode} - $errorBody');
      }

      // 参考アプリと同じ方式: utf8.decoderでtransform
      await for (final chunk in streamedResponse.stream.transform(utf8.decoder)) {
        // SSEフォーマットをパース
        final lines = chunk.split('\n');
        for (final line in lines) {
          if (line.startsWith('data: ')) {
            final data = line.substring(6).trim();
            if (data == '[DONE]') {
              return;
            }
            if (data.isNotEmpty) {
              try {
                final json = jsonDecode(data);
                final delta = json['choices']?[0]?['delta'];
                if (delta != null && delta['content'] != null) {
                  yield delta['content'] as String;
                }
                
                // 使用量情報
                if (json['usage'] != null && onUsage != null) {
                  final usage = json['usage'];
                  onUsage(TokenUsage(
                    promptTokens: usage['prompt_tokens'] ?? 0,
                    completionTokens: usage['completion_tokens'] ?? 0,
                    totalTokens: usage['total_tokens'] ?? 0,
                  ));
                }
              } catch (e) {
                // JSONパースエラーは無視
              }
            }
          }
        }
      }

      // 履歴に追加
      _history.add(currentMessage);
    } catch (error) {
      print('OpenAI APIエラー: $error');
      rethrow;
    }
  }
}
