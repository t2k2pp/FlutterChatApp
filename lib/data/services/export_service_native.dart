import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// ネイティブ（Android/iOS）用エクスポート実装
Future<void> downloadFile(Uint8List data, String fileName, String mimeType) async {
  try {
    // 一時ディレクトリに保存
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(data);

    // 共有ダイアログを表示
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: fileName,
    );
  } catch (e) {
    print('ファイルエクスポートエラー: $e');
    rethrow;
  }
}
