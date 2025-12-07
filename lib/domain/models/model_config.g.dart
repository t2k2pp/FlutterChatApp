// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ModelConfigImpl _$$ModelConfigImplFromJson(Map<String, dynamic> json) =>
    _$ModelConfigImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      provider: $enumDecode(_$AIProviderEnumMap, json['provider']),
      modelId: json['modelId'] as String,
      apiKey: json['apiKey'] as String?,
      endpoint: json['endpoint'] as String?,
      deployment: json['deployment'] as String?,
      systemInstruction: json['systemInstruction'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      topP: (json['topP'] as num).toDouble(),
      topK: (json['topK'] as num).toInt(),
      capabilities: (json['capabilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ModelConfigImplToJson(_$ModelConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'provider': _$AIProviderEnumMap[instance.provider]!,
      'modelId': instance.modelId,
      'apiKey': instance.apiKey,
      'endpoint': instance.endpoint,
      'deployment': instance.deployment,
      'systemInstruction': instance.systemInstruction,
      'temperature': instance.temperature,
      'topP': instance.topP,
      'topK': instance.topK,
      'capabilities': instance.capabilities,
    };

const _$AIProviderEnumMap = {
  AIProvider.gemini: 'gemini',
  AIProvider.openaiCompatible: 'openaiCompatible',
  AIProvider.azureOpenAI: 'azureOpenAI',
};
