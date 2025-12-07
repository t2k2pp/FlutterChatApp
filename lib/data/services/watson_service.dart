import 'package:flutter_chat_app/domain/models/message.dart';
import 'package:flutter_chat_app/domain/models/user_settings.dart';
import 'package:flutter_chat_app/domain/models/model_config.dart';
import 'package:flutter_chat_app/domain/enums/role.dart' as app_role;
import 'package:flutter_chat_app/domain/enums/watson_intervention_level.dart';
import 'package:flutter_chat_app/domain/enums/ai_provider.dart';
import 'package:flutter_chat_app/data/datasources/remote/gemini_service.dart';
import 'package:flutter_chat_app/data/datasources/remote/openai_service.dart';
import 'package:flutter_chat_app/data/datasources/remote/searxng_service.dart';
import 'package:flutter_chat_app/data/services/response_parser.dart';

/// Watson介入応答
class WatsonResponse {
  final String text;
  final String thoughts;

  WatsonResponse({required this.text, required this.thoughts});
}

/// Watson Service（オブザーバー/アドバイザーAI）
class WatsonService {
  /// 介入レベルに基づくシステムプロンプトを取得
  static String _getSystemPrompt(WatsonInterventionLevel level) {
    const basePrompt = '''
**役割定義:** あなたは「Watson」、ユーザーの信頼できるオブザーバー兼アドバイザーです。
あなたはユーザーとメインAIの間の会話を観察しています。
あなたの使命は、メインAIの提案が現実的で、理解しやすく、真にユーザーのニーズに沿っていることを確認することです。
あなたはユーザーの側に立ちます。

**介入ポリシー（いつ話すか）:**
''';

    String levelInstructions = '';

    switch (level) {
      case WatsonInterventionLevel.low:
        levelInstructions = '''
**介入レベル: MINIMAL（必要最小限）**
非常に控えめである必要があります。
1. **事実エラー:** メインAIが明確で客観的な事実の誤りを犯した場合のみ発言してください。
2. **安全/リスク:** アドバイスが危険または明らかに悪意がある場合のみ発言してください。
3. **完全に逸脱:** 会話がユーザーの元の意図から完全に外れた場合のみ発言してください。
4. **軽微な曖昧さや最適化:** 無視してください。沈黙を保ってください。
''';
        break;

      case WatsonInterventionLevel.high:
        levelInstructions = '''
**介入レベル: HIGH（積極的/細かい）**
あなたは完璧主義者のアドバイザーです。
1. **すべてを明確に:** わずかでもユーザーが誤解する可能性がある場合は、介入してください。
2. **最適化:** メインAIの回答が良いが、*より良く*または*より効率的*にできる場合は、提案してください。
3. **仮定を疑問視:** ユーザーが本当に求めているものかどうかを積極的に疑問視してください。
4. **積極的に存在:** 会話を頻繁にガイドすることを恐れないでください。
''';
        break;

      case WatsonInterventionLevel.medium:
      default:
        levelInstructions = '''
**介入レベル: NORMAL（バランス）**
1. **現実チェック:** メインAIが理論的には正しいが実際には困難なことを提案した場合。
2. **ギャップを埋める:** メインAIが説明なしに専門用語を使いすぎた場合。
3. **ユーザーを擁護:** ユーザーが漠然と同意しているように見えるが、理解していない可能性がある場合。
''';
        break;
    }

    const outputInstructions = '''

**制約:**
- **迷惑にならないこと:** あなたのレベルに従って、会話がうまくいっている場合は沈黙を守ってください。
- **ユーザーの代わりにならないこと:** あなたは視点を提供しますが、決定は下しません。
- **口調:** 知的で、地に足がついていて、親しみやすいが専門的。

**出力指示:**
- 介入が不要な場合は、正確に文字列を出力してください: "[NO_INTERVENTION]"
- 介入が必要な場合は、コメントを直接提供してください。簡潔に（通常は3文以内）。
''';

    return basePrompt + levelInstructions + outputInstructions;
  }

  /// ユーザーがWatsonに直接話しかけているかを検出
  static bool isAddressingWatson(String text) {
    final regex = RegExp(r'watson|ワトソン|わとそん', caseSensitive: false);
    return regex.hasMatch(text);
  }

  /// ユーザーに直接返信（ダイレクトモード）
  static Future<WatsonResponse> directReply(
    String userText,
    UserSettings settings,
    List<Message> history,
    bool webSearch,
  ) async {
    final modelId = settings.subModelId;
    final modelConfig = settings.models.firstWhere(
      (m) => m.id == modelId,
      orElse: () => settings.models.first,
    );

    final systemPrompt = _getSystemPrompt(settings.watsonInterventionLevel) +
        '\n\n(あなたは今、ユーザーに直接返信しています。介入チェックは無視してください。)';

    final watsonConfig = ModelConfig(
      id: modelConfig.id,
      name: modelConfig.name,
      provider: modelConfig.provider,
      modelId: modelConfig.modelId,
      apiKey: modelConfig.apiKey,
      endpoint: modelConfig.endpoint,
      deployment: modelConfig.deployment,
      systemInstruction: systemPrompt,
      temperature: modelConfig.temperature,
      topP: modelConfig.topP,
      topK: modelConfig.topK,
      capabilities: modelConfig.capabilities,
    );

    final context = history.map((m) {
      String prefix = 'USER';
      if (m.role == app_role.Role.model) prefix = 'MAIN AI';
      if (m.role == app_role.Role.watson) prefix = 'YOU (WATSON)';
      return '$prefix: ${m.text}';
    }).join('\n');

    String searchContext = '';
    if (webSearch && settings.search.enabled) {
      try {
        final results = await SearchService.search(
          userText,
          settings.search.baseUrl,
        );
        if (results.isNotEmpty) {
          searchContext = '\n[Web検索結果]:\n' +
              results.map((r) => '* [${r.title}](${r.url}): ${r.content}').join('\n');
        }
      } catch (e) {
        print('Watson検索失敗: $e');
      }
    }

    final fullPrompt = '$context\n$searchContext\nUSER (Watsonに直接): $userText';

    return await _generateResponse(fullPrompt, watsonConfig);
  }

  /// 最後のやり取りを観察し、介入すべきかを決定
  static Future<WatsonResponse?> observeAndIntervene(
    String userText,
    String aiResponseText,
    UserSettings settings,
  ) async {
    final modelId = settings.subModelId;
    final modelConfig = settings.models.firstWhere(
      (m) => m.id == modelId,
      orElse: () => settings.models.first,
    );

    final watsonConfig = ModelConfig(
      id: modelConfig.id,
      name: modelConfig.name,
      provider: modelConfig.provider,
      modelId: modelConfig.modelId,
      apiKey: modelConfig.apiKey,
      endpoint: modelConfig.endpoint,
      deployment: modelConfig.deployment,
      systemInstruction: _getSystemPrompt(settings.watsonInterventionLevel),
      temperature: modelConfig.temperature,
      topP: modelConfig.topP,
      topK: modelConfig.topK,
      capabilities: modelConfig.capabilities,
    );

    final prompt = '''
[OBSERVATION MODE]
以下は最新のやり取りです。ポリシーレベル（${settings.watsonInterventionLevel.label}）に基づいて、介入が必要かどうかを決定してください。

USER: "$userText"
MAIN AI: "$aiResponseText"

注意: メインAIが良い仕事をした場合は、"[NO_INTERVENTION]"を出力してください。
''';

    final response = await _generateResponse(prompt, watsonConfig);

    if (response.text.contains('[NO_INTERVENTION]') || response.text.trim().isEmpty) {
      return null;
    }
    return response;
  }

  /// 応答を生成
  static Future<WatsonResponse> _generateResponse(
    String prompt,
    ModelConfig config,
  ) async {
    dynamic service;

    if (config.provider == AIProvider.gemini) {
      service = GeminiService();
    } else {
      service = OpenAIService();
    }

    service.updateConfig(config);
    service.startChat([]);

    final parser = ResponseParser();
    String text = '';
    String thoughts = '';

    try {
      final stream = service.sendMessageStream(prompt, null, null);

      await for (final chunk in stream) {
        final parsed = parser.parse(chunk);
        text += parsed['contentDelta'] ?? '';
        thoughts += parsed['thoughtDelta'] ?? '';
      }

      final flushed = parser.flush();
      text += flushed['contentDelta'] ?? '';
      thoughts += flushed['thoughtDelta'] ?? '';
    } catch (e) {
      print('Watson思考失敗: $e');
      return WatsonResponse(text: '[NO_INTERVENTION]', thoughts: '');
    }

    return WatsonResponse(text: text, thoughts: thoughts);
  }
}
