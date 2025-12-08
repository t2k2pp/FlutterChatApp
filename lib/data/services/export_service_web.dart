// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

/// Web用エクスポート実装
Future<void> downloadFile(Uint8List data, String fileName, String mimeType) async {
  try {
    // Blobを作成
    final blob = html.Blob([data], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    
    // ダウンロードリンクを作成してクリック
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..style.display = 'none';
    
    html.document.body?.append(anchor);
    anchor.click();
    
    // クリーンアップ
    anchor.remove();
    html.Url.revokeObjectUrl(url);
  } catch (e) {
    print('ファイルエクスポートエラー: $e');
    rethrow;
  }
}
