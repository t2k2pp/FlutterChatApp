import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_chat_app/domain/enums/ai_provider.dart';

part 'model_config.freezed.dart';
part 'model_config.g.dart';

/// AIモデルの設定を表すモデル
@freezed
class ModelConfig with _$ModelConfig {
  const factory ModelConfig({
    required String id,
    required String name, // ユーザーフレンドリーな名前（例："My Creative Gemini"）
    required AIProvider provider,
    required String modelId, // モデル識別子（例："gemini-2.5-flash", "gpt-4", "llama3"）
    
    // 接続詳細
    String? apiKey,
    String? endpoint, // Azure/Local用
    String? deployment, // Azure固有
    
    // パラメーター
    required String systemInstruction,
    required double temperature,
    required double topP,
    required int topK,
    
    // 機能
    @Default([]) List<String> capabilities, // 'image' 等（'text'は暗黙的）
  }) = _ModelConfig;

  factory ModelConfig.fromJson(Map<String, dynamic> json) =>
      _$ModelConfigFromJson(json);
}
