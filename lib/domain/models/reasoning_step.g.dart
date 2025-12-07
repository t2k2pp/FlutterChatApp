// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reasoning_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReasoningStepImpl _$$ReasoningStepImplFromJson(Map<String, dynamic> json) =>
    _$ReasoningStepImpl(
      type: $enumDecode(_$ReasoningTypeEnumMap, json['type']),
      content: json['content'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
    );

Map<String, dynamic> _$$ReasoningStepImplToJson(_$ReasoningStepImpl instance) =>
    <String, dynamic>{
      'type': _$ReasoningTypeEnumMap[instance.type]!,
      'content': instance.content,
      'timestamp': instance.timestamp,
    };

const _$ReasoningTypeEnumMap = {
  ReasoningType.plan: 'plan',
  ReasoningType.search: 'search',
  ReasoningType.evaluate: 'evaluate',
  ReasoningType.thought: 'thought',
};
