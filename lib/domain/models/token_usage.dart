import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_usage.freezed.dart';
part 'token_usage.g.dart';

/// トークン使用量を表すモデル
@freezed
class TokenUsage with _$TokenUsage {
  const factory TokenUsage({
    required int promptTokens,
    required int completionTokens,
    required int totalTokens,
  }) = _TokenUsage;

  factory TokenUsage.fromJson(Map<String, dynamic> json) =>
      _$TokenUsageFromJson(json);
}
