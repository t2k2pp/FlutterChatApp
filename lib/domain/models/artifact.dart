import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_chat_app/domain/enums/artifact_type.dart';

part 'artifact.freezed.dart';
part 'artifact.g.dart';

/// アーティファクト（生成されたコード/HTML等）を表すモデル
@freezed
class Artifact with _$Artifact {
  const factory Artifact({
    required String id,
    required ArtifactType type,
    required String title,
    required String content,
    required String language,
  }) = _Artifact;

  factory Artifact.fromJson(Map<String, dynamic> json) =>
      _$ArtifactFromJson(json);
}
