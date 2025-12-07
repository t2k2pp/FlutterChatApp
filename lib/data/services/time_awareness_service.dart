/// 時間認識サービス
class TimeAwarenessService {
  /// 時間関連のクエリかどうかを判定
  static bool shouldInjectTime(String query) {
    final timeKeywords = [
      // 日本語
      '今日', '明日', '昨日', '今週', '今月', '今年',
      '日付', '曜日', '時間', '何時', 'いつ',
      // 英語
      'today', 'tomorrow', 'yesterday', 'this week', 'this month', 'this year',
      'date', 'time', 'when', 'what day', 'current',
    ];

    final lowerQuery = query.toLowerCase();
    return timeKeywords.any((keyword) => lowerQuery.contains(keyword));
  }

  /// 現在の日時文字列を取得
  static String getCurrentDateTime() {
    final now = DateTime.now();
    return now.toString();
  }
}
