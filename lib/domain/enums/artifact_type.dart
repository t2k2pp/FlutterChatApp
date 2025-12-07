/// アーティファクトの種類を表すEnum
enum ArtifactType {
  html,
  svg,
  code,
}

/// プログラミング言語を判定するヘルパー
extension ArtifactTypeExtension on ArtifactType {
  String get displayName {
    switch (this) {
      case ArtifactType.html:
        return 'HTML';
      case ArtifactType.svg:
        return 'SVG';
      case ArtifactType.code:
        return 'Code';
    }
  }
}
