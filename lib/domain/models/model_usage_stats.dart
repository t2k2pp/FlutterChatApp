import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_usage_stats.freezed.dart';
part 'model_usage_stats.g.dart';

/// モデル使用統計を表すモデル
@freezed
class ModelUsageStats with _$ModelUsageStats {
  const factory ModelUsageStats({
    required String modelId,
    @Default(0) int totalPromptTokens,
    @Default(0) int totalCompletionTokens,
    @Default(0) int totalTokens,
  }) = _ModelUsageStats;

  factory ModelUsageStats.fromJson(Map<String, dynamic> json) =>
      _$ModelUsageStatsFromJson(json);
}
