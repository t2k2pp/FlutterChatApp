import 'dart:convert';
import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:archive/archive.dart';

/// ファイル解析サービス
class FileParsingService {
  /// PDFファイルをテキストに変換
  static Future<String> parsePDF(Uint8List bytes, String fileName) async {
    try {
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final StringBuffer text = StringBuffer();

      for (int i = 0; i < document.pages.count; i++) {
        final PdfTextExtractor extractor = PdfTextExtractor(document);
        final String pageText = extractor.extractText(startPageIndex: i, endPageIndex: i);
        text.writeln('--- ページ ${i + 1} ---');
        text.writeln(pageText);
      }

      document.dispose();
      return text.toString();
    } catch (e) {
      print('PDFパースエラー: $e');
      return 'PDFの解析に失敗しました: $fileName';
    }
  }

  /// テキストファイルをパース
  static String parseText(Uint8List bytes, String fileName) {
    try {
      return utf8.decode(bytes);
    } catch (e) {
      print('テキストデコードエラー: $e');
      return 'テキストファイルの解析に失敗しました: $fileName';
    }
  }

  /// JSONファイルをパース
  static String parseJSON(Uint8List bytes, String fileName) {
    try {
      final text = utf8.decode(bytes);
      final json = jsonDecode(text);
      // 整形されたJSONとして返す
      return const JsonEncoder.withIndent('  ').convert(json);
    } catch (e) {
      print('JSONパースエラー: $e');
      return 'JSONファイルの解析に失敗しました: $fileName';
    }
  }

  /// ZIPファイルをパース
  static String parseZIP(Uint8List bytes, String fileName) {
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      final buffer = StringBuffer();
      buffer.writeln('=== ZIPファイルの内容: $fileName ===');
      
      for (final file in archive) {
        buffer.writeln('ファイル: ${file.name} (${file.size} bytes)');
      }

      return buffer.toString();
    } catch (e) {
      print('ZIPパースエラー: $e');
      return 'ZIPファイルの解析に失敗しました: $fileName';
    }
  }

  /// 画像をBase64に変換
  static String imageToBase64(Uint8List bytes, String mimeType) {
    final base64String = base64Encode(bytes);
    return base64String;
  }

  /// ファイル拡張子から適切なパース関数を選択
  static Future<String> parseFile(
    Uint8List bytes,
    String fileName,
    String mimeType,
  ) async {
    final extension = fileName.split('.').last.toLowerCase();

    switch (extension) {
      case 'pdf':
        return await parsePDF(bytes, fileName);
      case 'txt':
      case 'md':
      case 'csv':
        return parseText(bytes, fileName);
      case 'json':
        return parseJSON(bytes, fileName);
      case 'zip':
        return parseZIP(bytes, fileName);
      default:
        return 'サポートされていないファイル形式: $fileName';
    }
  }
}
