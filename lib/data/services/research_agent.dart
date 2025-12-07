import 'package:flutter_chat_app/domain/models/reasoning_step.dart';
import 'package:flutter_chat_app/domain/models/search_config.dart';
import 'package:flutter_chat_app/domain/models/message.dart';
import 'package:flutter_chat_app/domain/models/model_config.dart';
import 'package:flutter_chat_app/data/datasources/remote/searxng_service.dart';
import 'package:flutter_chat_app/data/datasources/remote/gemini_service.dart';
import 'package:flutter_chat_app/data/datasources/remote/openai_service.dart';
import 'package:flutter_chat_app/data/services/response_parser.dart';
import 'package:flutter_chat_app/domain/enums/ai_provider.dart';

/// Research Agent（深い調査用の反復検索+統合）
class ResearchAgent {
  final void Function(List<ReasoningStep>) onReasoningUpdate;
  final List<ReasoningStep> _logs = [];

  ResearchAgent(this.onReasoningUpdate);

  /// Deep Researchを実行
  Future<String> executeDeepResearch(
    String query,
    SearchConfig searchConfig,
    List<Message> conversationHistory,
    ModelConfig config,
  ) async {
    _logs.clear();
    _addLog(ReasoningType.plan, 'Deep Researchを開始します...');

    final findings = <String>[];
    int iteration = 0;

    while (iteration < searchConfig.maxIterations) {
      iteration++;
      _addLog(ReasoningType.search, 'イテレーション $iteration: 検索中...');

      // 検索クエリを生成（初回は元のクエリ、以降は発見に基づく）
      String searchQuery = query;
      if (findings.isNotEmpty) {
        searchQuery = await _generateFollowUpQuery(
          query,
          findings.join('\n\n'),
          config,
        );
        _addLog(ReasoningType.search, 'フォローアップクエリ: $searchQuery');
      }

      // 検索を実行
      try {
        final results = await SearchService.search(
          searchQuery,
          searchConfig.baseUrl,
        );

        if (results.isEmpty) {
          _addLog(ReasoningType.search, 'イテレーション $iteration: 結果なし');
          break;
        }

        final formatted = results
            .map((r) => '* [${r.title}](${r.url}): ${r.content}')
            .join('\n');

        findings.add('=== イテレーション $iteration ===\n$formatted');
        _addLog(ReasoningType.search, '${results.length}件の結果を取得しました');

        // 結果を評価: 続行すべきか？
        if (iteration < searchConfig.maxIterations) {
          final shouldContinue = await _evaluateNeedMoreResearch(
            query,
            findings.join('\n\n'),
            config,
          );

          if (!shouldContinue) {
            _addLog(ReasoningType.evaluate, '十分な情報が収集されました');
            break;
          }
        }
      } catch (e) {
        _addLog(ReasoningType.search, '検索エラー: $e');
        break;
      }
    }

    // すべての発見を統合
    _addLog(ReasoningType.evaluate, '結果を統合しています...');
    final synthesized = await _synthesizeFindings(query, findings, config);

    return synthesized;
  }

  /// フォローアップクエリを生成
  Future<String> _generateFollowUpQuery(
    String originalQuery,
    String previousFindings,
    ModelConfig config,
  ) async {
    final prompt = '''
元の質問: "$originalQuery"

これまでの発見:
$previousFindings

上記の発見に基づいて、まだ答えられていない側面や深く掘り下げるべき点を特定し、
次の検索クエリ（1つ）を生成してください。クエリのみを返してください。
''';

    return await _callAI(prompt, config);
  }

  /// さらなる調査が必要かを評価
  Future<bool> _evaluateNeedMoreResearch(
    String originalQuery,
    String findings,
    ModelConfig config,
  ) async {
    final prompt = '''
元の質問: "$originalQuery"

これまでの発見:
$findings

この質問に完全に答えるために、さらに調査が必要ですか？
「はい」または「いいえ」のみで答えてください。
''';

    final response = await _callAI(prompt, config);
    return response.toLowerCase().contains('はい') ||
        response.toLowerCase().contains('yes');
  }

  /// 発見を統合
  Future<String> _synthesizeFindings(
    String originalQuery,
    List<String> findings,
    ModelConfig config,
  ) async {
    final prompt = '''
元の質問: "$originalQuery"

リサーチ結果:
${findings.join('\n\n')}

上記のすべてのリサーチ結果を統合し、元の質問に対する包括的で十分に引用された回答を提供してください。
各主張には情報源を明記してください。
''';

    return await _callAI(prompt, config);
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
      print('Research Agent AIコールエラー: $e');
      return 'エラーが発生しました';
    }
  }

  /// ログ

を追加
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
