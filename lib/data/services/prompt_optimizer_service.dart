import 'package:flutter_chat_app/data/datasources/remote/gemini_service.dart';
import 'package:flutter_chat_app/data/datasources/remote/openai_service.dart';
import 'package:flutter_chat_app/domain/models/model_config.dart';
import 'package:flutter_chat_app/domain/enums/ai_provider.dart';

/// プロンプト最適化サービス
/// AIを使ってシステム指示を改善する
class PromptOptimizerService {
  final GeminiService _geminiService = GeminiService();
  final OpenAIService _openaiService = OpenAIService();

  /// システム指示を最適化する
  Future<String> optimizePrompt(String originalPrompt, ModelConfig config) async {
    final metaPrompt = '''
You are an expert prompt engineer. Your task is to rewrite the following system instruction to be more effective, detailed, and robust for an LLM.
Retain the original intent but improve clarity, add constraints if necessary, and ensure the tone is appropriate.

Original Instruction:
"$originalPrompt"

Return ONLY the rewritten instruction. Do not add conversational filler.
''';

    try {
      String optimized = '';
      
      if (config.provider == AIProvider.gemini) {
        _geminiService.updateConfig(config.copyWith(
          systemInstruction: '', // メタプロンプト自体がシステム指示になる
        ));
        _geminiService.startChat([]);
        
        await for (final chunk in _geminiService.sendMessageStream(metaPrompt, null, null)) {
          optimized += chunk;
        }
      } else {
        _openaiService.updateConfig(config.copyWith(
          systemInstruction: '', // メタプロンプト自体がシステム指示になる
        ));
        _openaiService.startChat([]);
        
        await for (final chunk in _openaiService.sendMessageStream(metaPrompt, null, null)) {
          optimized += chunk;
        }
      }
      
      return optimized.trim();
    } catch (e) {
      print('プロンプト最適化エラー: $e');
      return originalPrompt; // エラー時は元のプロンプトを返す
    }
  }
}
