import 'dart:math';

/// ユニークなIDを生成するユーティリティクラス
class IdGenerator {
  static const _chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  static final _random = Random();

  /// ランダムな英数字IDを生成（JavaScriptの実装に合わせて）
  static String generate() {
    return List.generate(
      13,
      (index) => _chars[_random.nextInt(_chars.length)],
    ).join();
  }
}
