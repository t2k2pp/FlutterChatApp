// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchConfigImpl _$$SearchConfigImplFromJson(Map<String, dynamic> json) =>
    _$SearchConfigImpl(
      enabled: json['enabled'] as bool,
      provider: json['provider'] as String? ?? 'searxng',
      baseUrl: json['baseUrl'] as String,
      deepResearchEnabled: json['deepResearchEnabled'] as bool,
      maxIterations: (json['maxIterations'] as num?)?.toInt() ?? 3,
    );

Map<String, dynamic> _$$SearchConfigImplToJson(_$SearchConfigImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'provider': instance.provider,
      'baseUrl': instance.baseUrl,
      'deepResearchEnabled': instance.deepResearchEnabled,
      'maxIterations': instance.maxIterations,
    };
