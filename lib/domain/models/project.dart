import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

/// プロジェクト/Gemsを表すモデル
@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    required String description,
    required String customInstruction, // 特定のペルソナまたは指示
    required String knowledge, // 蓄積された知識コンテキスト
    required int updatedAt,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
