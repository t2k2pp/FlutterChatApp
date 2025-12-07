// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSettingsImpl _$$UserSettingsImplFromJson(Map<String, dynamic> json) =>
    _$UserSettingsImpl(
      models: (json['models'] as List<dynamic>)
          .map((e) => ModelConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeModelId: json['activeModelId'] as String,
      subModelId: json['subModelId'] as String,
      watsonInterventionLevel: $enumDecode(
          _$WatsonInterventionLevelEnumMap, json['watsonInterventionLevel']),
      projects: (json['projects'] as List<dynamic>)
          .map((e) => Project.fromJson(e as Map<String, dynamic>))
          .toList(),
      search: SearchConfig.fromJson(json['search'] as Map<String, dynamic>),
      tts: TTSConfig.fromJson(json['tts'] as Map<String, dynamic>),
      timeAwareness: json['timeAwareness'] as bool? ?? true,
    );

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'models': instance.models,
      'activeModelId': instance.activeModelId,
      'subModelId': instance.subModelId,
      'watsonInterventionLevel':
          _$WatsonInterventionLevelEnumMap[instance.watsonInterventionLevel]!,
      'projects': instance.projects,
      'search': instance.search,
      'tts': instance.tts,
      'timeAwareness': instance.timeAwareness,
    };

const _$WatsonInterventionLevelEnumMap = {
  WatsonInterventionLevel.low: 'low',
  WatsonInterventionLevel.medium: 'medium',
  WatsonInterventionLevel.high: 'high',
};
