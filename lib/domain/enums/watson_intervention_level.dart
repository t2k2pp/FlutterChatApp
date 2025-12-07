/// Watsonの介入レベルを表すEnum
enum WatsonInterventionLevel {
  low('low'),       // 最小限：事実エラーまたは安全リスクのみ
  medium('medium'), // 通常：明確さとフローのバランス
  high('high');     // 積極的：曖昧さに対する高い感度

  const WatsonInterventionLevel(this.value);
  final String value;

  static WatsonInterventionLevel fromString(String value) {
    return WatsonInterventionLevel.values.firstWhere(
      (e) => e.value == value,
      orElse: () => WatsonInterventionLevel.medium,
    );
  }

  String get label {
    switch (this) {
      case WatsonInterventionLevel.low:
        return 'Minimal';
      case WatsonInterventionLevel.medium:
        return 'Balanced';
      case WatsonInterventionLevel.high:
        return 'Proactive';
    }
  }
}
