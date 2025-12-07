/// レスポンスパーサー（<think>タグの抽出用）
class ResponseParser {
  final StringBuffer _buffer = StringBuffer();
  final StringBuffer _content = StringBuffer();
  final StringBuffer _thought = StringBuffer();
  
  bool _inThink = false;
  int _thinkDepth = 0;

  /// チャンクをパースして、contentDeltaとthoughtDeltaを返す
  Map<String, String> parse(String chunk) {
    String contentDelta = '';
    String thoughtDelta = '';

    for (int i = 0; i < chunk.length; i++) {
      final char = chunk[i];
      _buffer.write(char);

      // <think>の開始を検出
      if (_buffer.toString().endsWith('<think>')) {
        _inThink = true;
        _thinkDepth++;
        _buffer.clear();
        continue;
      }

      // </think>の終了を検出
      if (_buffer.toString().endsWith('</think>')) {
        if (_inThink) {
          _thinkDepth--;
          if (_thinkDepth == 0) {
            _inThink = false;
          }
          // "</think>"を削除
          final bufferStr = _buffer.toString();
          _buffer.clear();
          _buffer.write(bufferStr.substring(0, bufferStr.length - 8));
          
          if (!_inThink) {
            // thinkコンテンツをフラッシュ
            final thinkContent = _buffer.toString();
            _thought.write(thinkContent);
            thoughtDelta = thinkContent;
            _buffer.clear();
          }
          continue;
        }
      }

      // 通常のコンテンツまたは思考コンテンツに追加
      if (!_inThink) {
        // タグが完成していない場合はバッファに保持
        final bufferStr = _buffer.toString();
        if (!bufferStr.contains('<') || bufferStr.endsWith('>')) {
          final text = _buffer.toString();
          if (!text.startsWith('<think>') && !text.startsWith('</think>')) {
            _content.write(text);
            contentDelta = text;
            _buffer.clear();
          }
        }
      }
    }

    return {
      'contentDelta': contentDelta,
      'thoughtDelta': thoughtDelta,
    };
  }

  /// バッファに残っているコンテンツをフラッシュ
  Map<String, String> flush() {
    String contentDelta = '';
    String thoughtDelta = '';

    if (_buffer.isNotEmpty) {
      final remaining = _buffer.toString();
      if (_inThink) {
        _thought.write(remaining);
        thoughtDelta = remaining;
      } else {
        _content.write(remaining);
        contentDelta = remaining;
      }
      _buffer.clear();
    }

    return {
      'contentDelta': contentDelta,
      'thoughtDelta': thoughtDelta,
    };
  }

  /// 蓄積されたコンテンツを取得
  String get content => _content.toString();

  /// 蓄積された思考を取得
  String get thought => _thought.toString();

  /// リセット
  void reset() {
    _buffer.clear();
    _content.clear();
    _thought.clear();
    _inThink = false;
    _thinkDepth = 0;
  }
}
