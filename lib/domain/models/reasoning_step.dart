import 'package:freezed_annotation/freezed_annotation.dart';

part 'reasoning_step.freezed.dart';
part 'reasoning_step.g.dart';

/// 推論ステップの種類を表すEnum
enum ReasoningType {
  plan,
  search,
  evaluate,
  thought,
}

/// 推論ステップを表すモデル（Deep Researchの可視性用）
@freezed
class ReasoningStep with _$ReasoningStep {
  const factory ReasoningStep({
    required ReasoningType type,
    required String content,
    required int timestamp,
  }) = _ReasoningStep;

  factory ReasoningStep.fromJson(Map<String, dynamic> json) =>
      _$ReasoningStepFromJson(json);
}
