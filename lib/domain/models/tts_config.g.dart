// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tts_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TTSConfigImpl _$$TTSConfigImplFromJson(Map<String, dynamic> json) =>
    _$TTSConfigImpl(
      voiceURI: json['voiceURI'] as String?,
      speed: (json['speed'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$TTSConfigImplToJson(_$TTSConfigImpl instance) =>
    <String, dynamic>{
      'voiceURI': instance.voiceURI,
      'speed': instance.speed,
    };
