// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: json['id'] as String,
      role: $enumDecode(_$RoleEnumMap, json['role']),
      text: json['text'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
      isError: json['isError'] as bool? ?? false,
      reasoningLogs: (json['reasoningLogs'] as List<dynamic>?)
          ?.map((e) => ReasoningStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      includedInContext: json['includedInContext'] as bool? ?? true,
      watsonChecked: json['watsonChecked'] as bool?,
      usage: json['usage'] == null
          ? null
          : TokenUsage.fromJson(json['usage'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => MessageImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': _$RoleEnumMap[instance.role]!,
      'text': instance.text,
      'timestamp': instance.timestamp,
      'isError': instance.isError,
      'reasoningLogs': instance.reasoningLogs,
      'includedInContext': instance.includedInContext,
      'watsonChecked': instance.watsonChecked,
      'usage': instance.usage,
      'images': instance.images,
    };

const _$RoleEnumMap = {
  Role.user: 'user',
  Role.model: 'model',
  Role.watson: 'watson',
};
