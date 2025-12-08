/// レスポンスパーサー（<think>タグの抽出用）
/// 日本語対応版 - チャンク単位で処理
class ResponseParser {
  final StringBuffer _pendingContent = StringBuffer();
  bool _inThink = false;
  
  /// チャンクをパースして、contentDeltaとthoughtDeltaを返す
  Map<String, String> parse(String chunk) {
    String contentDelta = '';
    String thoughtDelta = '';
    
    // pendingContentに追加
    _pendingContent.write(chunk);
    String text = _pendingContent.toString();
    
    // <think>タグの開始を処理
    while (text.contains('<think>')) {
      final startIndex = text.indexOf('<think>');
      
      if (!_inThink) {
        // <think>より前のコンテンツを出力
        contentDelta += text.substring(0, startIndex);
      } else {
        // 既にthink内なら、thoughtに追加
        thoughtDelta += text.substring(0, startIndex);
      }
      
      _inThink = true;
      text = text.substring(startIndex + 7); // '<think>'.length
    }
    
    // </think>タグの終了を処理
    while (_inThink && text.contains('</think>')) {
      final endIndex = text.indexOf('</think>');
      
      // </think>より前のコンテンツをthoughtに追加
      thoughtDelta += text.substring(0, endIndex);
      
      _inThink = false;
      text = text.substring(endIndex + 8); // '</think>'.length
    }
    
    // 残りのテキストを処理
    if (_inThink) {
      // まだthink内の場合、</think>が来るまで保持
      // ただし、</think>が部分的に含まれている可能性を考慮
      if (text.contains('<')) {
        // '<'で終わる可能性があるので保持
        final lastLt = text.lastIndexOf('<');
        thoughtDelta += text.substring(0, lastLt);
        _pendingContent.clear();
        _pendingContent.write(text.substring(lastLt));
      } else {
        thoughtDelta += text;
        _pendingContent.clear();
      }
    } else {
      // 通常のコンテンツ
      // <think>が部分的に含まれている可能性を考慮
      if (text.contains('<')) {
        final lastLt = text.lastIndexOf('<');
        contentDelta += text.substring(0, lastLt);
        _pendingContent.clear();
        _pendingContent.write(text.substring(lastLt));
      } else {
        contentDelta += text;
        _pendingContent.clear();
      }
    }
    
    return {
      'contentDelta': contentDelta,
      'thoughtDelta': thoughtDelta,
    };
  }

  /// バッファに残っているコンテンツをフラッシュ
  Map<String, String> flush() {
    final remaining = _pendingContent.toString();
    _pendingContent.clear();
    
    if (_inThink) {
      return {
        'contentDelta': '',
        'thoughtDelta': remaining,
      };
    } else {
      return {
        'contentDelta': remaining,
        'thoughtDelta': '',
      };
    }
  }

  /// リセット
  void reset() {
    _pendingContent.clear();
    _inThink = false;
  }
}
