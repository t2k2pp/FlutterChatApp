import 'dart:io';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_chat_app/domain/models/message.dart';
import 'package:flutter_chat_app/domain/enums/role.dart';

/// エクスポートサービス
class ExportService {
  /// チャットをZIP（Markdown）でエクスポート
  static Future<void> exportToZip(
    String sessionTitle,
    List<Message> messages,
  ) async {
    try {
      final archive = Archive();

      // 各メッセージをMarkdownファイルとして作成
      int messageIndex = 0;
      for (final msg in messages) {
        messageIndex++;
        final roleName = _getRoleName(msg.role);
        final fileName = '${messageIndex.toString().padLeft(3, '0')}_$roleName.md';
        
        final content = '''
# ${msg.role == Role.user ? 'ユーザー' : (msg.role == Role.watson ? 'Watson' : 'AI')}

${msg.text}

---
タイムスタンプ: ${DateTime.fromMillisecondsSinceEpoch(msg.timestamp).toString()}
''';

        final fileData = utf8.encode(content);
        archive.addFile(ArchiveFile(fileName, fileData.length, fileData));
      }

      // ZIPファイルをエンコード
      final zipData = ZipEncoder().encode(archive);

      if (zipData == null) {
        throw Exception('ZIPファイルの作成に失敗しました');
      }

      // 一時ディレクトリに保存
      final tempDir = await getTemporaryDirectory();
      final zipFile = File('${tempDir.path}/$sessionTitle.zip');
      await zipFile.writeAsBytes(zipData);

      // 共有
      await Share.shareXFiles(
        [XFile(zipFile.path)],
        subject: sessionTitle,
      );
    } catch (e) {
      print('ZIPエクスポートエラー: $e');
      rethrow;
    }
  }

  /// チャットをPDFでエクスポート（簡易版）
  static Future<void> exportToPDF(
    String sessionTitle,
    List<Message> messages,
  ) async {
    try {
      final pdf = pw.Document();

      // 各メッセージをページに追加
      for (final msg in messages) {
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    _getRoleName(msg.role),
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(msg.text),
                  pw.SizedBox(height: 10),
                  pw.Divider(),
                  pw.Text(
                    'タイムスタンプ: ${DateTime.fromMillisecondsSinceEpoch(msg.timestamp).toString()}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              );
            },
          ),
        );
      }

      // 一時ディレクトリに保存
      final tempDir = await getTemporaryDirectory();
      final pdfFile = File('${tempDir.path}/$sessionTitle.pdf');
      await pdfFile.writeAsBytes(await pdf.save());

      // 共有
      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        subject: sessionTitle,
      );
    } catch (e) {
      print('PDFエクスポートエラー: $e');
      rethrow;
    }
  }

  /// ロール名を取得
  static String _getRoleName(Role role) {
    switch (role) {
      case Role.user:
        return 'user';
      case Role.model:
        return 'ai';
      case Role.watson:
        return 'watson';
    }
  }
}
