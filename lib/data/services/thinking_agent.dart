import 'package:flutter_chat_app/domain/models/reasoning_step.dart';
import 'package:flutter_chat_app/domain/enums/thinking_level.dart';
import 'package:flutter_chat_app/data/datasources/remote/gemini_service.dart';
import 'package:flutter_chat_app/data/datasources/remote/openai_service.dart';
import 'package:flutter_chat_app/data/services/response_parser.dart';
import 'package:flutter_chat_app/domain/models/model_config.dart';
import 'package:flutter_chat_app/domain/enums/ai_provider.dart';

/// Thinking Agent（多段階推論システム）
class ThinkingAgent {
  final void Function(List<ReasoningStep>) onReasoningUpdate;
  final List<ReasoningStep> _logs = [];

  ThinkingAgent(this.onReasoningUpdate);

  /// 思考を実行して強化されたプロンプトを返す
  Future<String> executeThinking(
    String userInput,
    ThinkingLevel level,
    String extraContext,
    ModelConfig config,
  ) async {
    _logs.clear();

    switch (level) {
      case ThinkingLevel.low:
        return await _quickThinking(userInput, extraContext, config);
      case ThinkingLevel.medium:
        return await _balancedThinking(userInput, extraContext, config);
      case ThinkingLevel.high:
        return await _deepThinking(userInput, extraContext, config);
      case ThinkingLevel.off:
        return '$extraContext\n\n$userInput';
    }
  }

  /// Quick Thinking: Plan -> Answer
  Future<String> _quickThinking(
    String userInput,
    String extraContext,
    ModelConfig config,
  ) async {
    _addLog(ReasoningType.plan, '計画を立てています...');

    final planPrompt = '''
$extraContext

ユーザーの質問: "$userInput"

この質問に答えるための簡潔な計画を立ててください。計画のみを箇条書きで出力してください。
''';

    final plan = await _callAI(planPrompt, config);
    _addLog(ReasoningType.plan, plan);

    return '''
$extraContext

以下は、ユーザーの質問に答えるための計画です：
$plan

ユーザーの質問: "$userInput"

上記の計画に従って、詳細で役立つ回答を提供してください。
''';
  }

  /// Balanced Thinking: Plan -> Draft -> Critique -> Refine
  Future<String> _balancedThinking(
    String userInput,
    String extraContext,
    ModelConfig config,
  ) async {
    // Plan
    _addLog(ReasoningType.plan, '計画を立てています...');
    final planPrompt = '''
$extraContext

ユーザーの質問: "$userInput"

この質問に答えるための詳細な計画を立ててください。
''';
    final plan = await _callAI(planPrompt, config);
    _addLog(ReasoningType.plan, plan);

    // Draft
    _addLog(ReasoningType.thought, 'ドラフトを作成しています...');
    final draftPrompt = '''
計画: $plan

ユーザーの質問: "$userInput"

上記の計画に基づいて、初回のドラフト回答を作成してください。
''';
    final draft = await _callAI(draftPrompt, config);
    _addLog(ReasoningType.thought, draft);

    // Critique
    _addLog(ReasoningType.evaluate, 'ドラフトを評価しています...');
    final critiquePrompt = '''
ドラフト回答:
$draft

ユーザーの質問: "$userInput"

上記のドラフト回答を批判的に評価してください。改善点を指摘してください。
''';
    final critique = await _callAI(critiquePrompt, config);
    _addLog(ReasoningType.evaluate, critique);

    // Refine
    return '''
$extraContext

元のドラフト: $draft

批評: $critique

ユーザーの質問: "$userInput"

批評に基づいてドラフトを改善し、最終的な回答を提供してください。
''';
  }

  /// Deep Thinking: Plan -> Draft -> Critique -> Refine -> Critique -> Final Polish
  Future<String> _deepThinking(
    String userInput,
    String extraContext,
    ModelConfig config,
  ) async {
    // Plan
    _addLog(ReasoningType.plan, '綿密な計画を立てています...');
    final planPrompt = '''
$extraContext

ユーザーの質問: "$userInput"

この質問に答えるための非常に詳細な計画を立ててください。複数の角度から検討してください。
''';
    final plan = await _callAI(planPrompt, config);
    _addLog(ReasoningType.plan, plan);

    // Draft
    _addLog(ReasoningType.thought, '詳細なドラフトを作成しています...');
    final draftPrompt = '''
計画: $plan

ユーザーの質問: "$userInput"

上記の計画に基づいて、包括的なドラフト回答を作成してください。
''';
    final draft = await _callAI(draftPrompt, config);
    _addLog(ReasoningType.thought, draft);

    // First Critique
    _addLog(ReasoningType.evaluate, '初回評価を実施しています...');
    final critique1Prompt = '''
ドラフト回答:
$draft

この回答を厳しく評価してください。論理的な飛躍、不正確さ、改善の余地を指摘してください。
''';
    final critique1 = await _callAI(critique1Prompt, config);
    _addLog(ReasoningType.evaluate, critique1);

    // Refine
    _addLog(ReasoningType.thought, '改善版を作成しています...');
    final refinePrompt = '''
元のドラフト: $draft

批評: $critique1

批評に基づいて回答を大幅に改善してください。
''';
    final refined = await _callAI(refinePrompt, config);
    _addLog(ReasoningType.thought, refined);

    // Second Critique
    _addLog(ReasoningType.evaluate, '最終評価を実施しています...');
    final critique2Prompt = '''
改善された回答:
$refined

この回答を再評価してください。まだ改善できる点はありますか？
''';
    final critique2 = await _callAI(critique2Prompt, config);
    _addLog(ReasoningType.evaluate, critique2);

    // Final Polish
    return '''
$extraContext

改善された回答: $refined

最終批評: $critique2

ユーザーの質問: "$userInput"

最終批評を考慮して、完璧に磨き上げられた最終回答を提供してください。
''';
  }

  /// AIを呼び出して応答を取得
  Future<String> _callAI(String prompt, ModelConfig config) async {
    dynamic service;

    if (config.provider == AIProvider.gemini) {
      service = GeminiService();
    } else {
      service = OpenAIService();
    }

    service.updateConfig(config);
    service.startChat([]);

    final parser = ResponseParser();
    final buffer = StringBuffer();

    try {
      final stream = service.sendMessageStream(prompt, null, null);

      await for (final chunk in stream) {
        final parsed = parser.parse(chunk);
        buffer.write(parsed['contentDelta']);
      }

      final flushed = parser.flush();
      buffer.write(flushed['contentDelta']);

      return buffer.toString().trim();
    } catch (e) {
      print('Thinking Agent AIコールエラー: $e');
      return 'エラーが発生しました';
    }
  }

  /// ログを追加
  void _addLog(ReasoningType type, String content) {
    final log = ReasoningStep(
      type: type,
      content: content,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _logs.add(log);
    onReasoningUpdate(List.from(_logs));
  }
}
