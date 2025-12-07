/// セッション管理ユーティリティ
class SessionUtils {
  /// 最初のメッセージからセッションタイトルを生成
  static String generateTitle(String firstMessage) {
    // 最初の50文字を取得
    String title = firstMessage.trim();
    if (title.length > 50) {
      title = '${title.substring(0, 50)}...';
    }
    
    // 改行を削除
    title = title.replaceAll('\n', ' ').replaceAll('\r', ' ');
    
    // 複数のスペースを1つに
    title = title.replaceAll(RegExp(r'\s+'), ' ');
    
    return title.isNotEmpty ? title : '新規チャット';
  }
}
