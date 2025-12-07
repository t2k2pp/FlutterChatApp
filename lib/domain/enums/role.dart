/// メッセージの役割を表すEnum
enum Role {
  user('user'),
  model('model'),
  watson('watson'); // オブザーバー/アドバイザーロール

  const Role(this.value);
  final String value;

  static Role fromString(String value) {
    return Role.values.firstWhere(
      (e) => e.value == value,
      orElse: () => Role.user,
    );
  }
}
