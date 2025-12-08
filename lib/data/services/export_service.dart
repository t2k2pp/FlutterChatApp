import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_chat_app/domain/models/message.dart';
import 'package:flutter_chat_app/domain/enums/role.dart';

// プラットフォーム固有のエクスポート実装
import 'export_service_stub.dart'
    if (dart.library.io) 'export_service_native.dart'
    if (dart.library.html) 'export_service_web.dart' as platform;

/// エクスポートサービス
class ExportService {
  /// チャットをZIP（Markdown）でエクスポート
  static Future<void> exportToZip(
    String sessionTitle,
    List<Message> messages,
  ) async {
    final zipData = await _createZipData(sessionTitle, messages);
    await platform.downloadFile(zipData, '$sessionTitle.zip', 'application/zip');
  }

  /// チャットをPDFでエクスポート
  static Future<void> exportToPDF(
    String sessionTitle,
    List<Message> messages,
  ) async {
    final pdfData = await _createPdfData(sessionTitle, messages);
    await platform.downloadFile(pdfData, '$sessionTitle.pdf', 'application/pdf');
  }

  /// ZIPデータを作成
  static Future<Uint8List> _createZipData(
    String sessionTitle,
    List<Message> messages,
  ) async {
    final archive = Archive();

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

    final zipData = ZipEncoder().encode(archive);
    if (zipData == null) {
      throw Exception('ZIPファイルの作成に失敗しました');
    }
    return Uint8List.fromList(zipData);
  }

  /// PDFデータを作成
  static Future<Uint8List> _createPdfData(
    String sessionTitle,
    List<Message> messages,
  ) async {
    final pdf = pw.Document();

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

    return await pdf.save();
  }

  static String _getRoleName(Role role) {
    return switch (role) {
      Role.user => 'user',
      Role.model => 'ai',
      Role.watson => 'watson',
    };
  }
}
