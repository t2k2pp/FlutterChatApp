// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artifact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArtifactImpl _$$ArtifactImplFromJson(Map<String, dynamic> json) =>
    _$ArtifactImpl(
      id: json['id'] as String,
      type: $enumDecode(_$ArtifactTypeEnumMap, json['type']),
      title: json['title'] as String,
      content: json['content'] as String,
      language: json['language'] as String,
    );

Map<String, dynamic> _$$ArtifactImplToJson(_$ArtifactImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ArtifactTypeEnumMap[instance.type]!,
      'title': instance.title,
      'content': instance.content,
      'language': instance.language,
    };

const _$ArtifactTypeEnumMap = {
  ArtifactType.html: 'html',
  ArtifactType.svg: 'svg',
  ArtifactType.code: 'code',
};
