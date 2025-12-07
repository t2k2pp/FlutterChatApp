/// 思考レベルを表すEnum
enum ThinkingLevel {
  off('off'),
  low('low'),       // Plan -> Answer
  medium('medium'), // Plan -> Draft -> Critique -> Refine
  high('high');     // Plan -> Draft -> Critique -> Refine -> Critique -> Final Polish

  const ThinkingLevel(this.value);
  final String value;

  static ThinkingLevel fromString(String value) {
    return ThinkingLevel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ThinkingLevel.off,
    );
  }

  String get label {
    switch (this) {
      case ThinkingLevel.off:
        return 'Off';
      case ThinkingLevel.low:
        return 'Quick';
      case ThinkingLevel.medium:
        return 'Balanced';
      case ThinkingLevel.high:
        return 'Deep';
    }
  }
}
