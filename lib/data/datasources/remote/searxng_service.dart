import 'dart:convert';
import 'package:http/http.dart' as http;

/// 検索結果モデル
class SearchResult {
  final String title;
  final String url;
  final String content;
  final String? source;

  SearchResult({
    required this.title,
    required this.url,
    required this.content,
    this.source,
  });
}

/// SearXNG検索サービス
class SearchService {
  /// 検索を実行
  static Future<List<SearchResult>> search(String query, String baseUrl) async {
    try {
      // 末尾のスラッシュを削除
      final cleanUrl = baseUrl.replaceAll(RegExp(r'/$'), '');
      final searchUrl = Uri.parse('$cleanUrl/search');

      final params = {
        'q': query,
        'format': 'json',
        'language': 'auto',
      };

      final uri = searchUrl.replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('検索失敗: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      if (data['results'] == null) return [];

      final results = (data['results'] as List)
          .take(5)
          .map((r) => SearchResult(
                title: r['title'] ?? '',
                url: r['url'] ?? '',
                content: r['content'] ?? r['snippet'] ?? '',
                source: r['engine'],
              ))
          .toList();

      return results;
    } catch (error) {
      print('SearXNGエラー: $error');
      rethrow;
    }
  }
}
