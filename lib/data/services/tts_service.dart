// TTS Service - Stub implementation for cross-platform compatibility
// TODO: Re-enable flutter_tts when Android 16 compatibility is fixed

/// 音声オプション
class VoiceOption {
  final String name;
  final String locale;
  final String? voiceURI;

  VoiceOption({
    required this.name,
    required this.locale,
    this.voiceURI,
  });
}

/// TTSサービス（スタブ実装）
class TTSService {
  List<VoiceOption> _availableVoices = [];
  bool _isSpeaking = false;
  void Function()? _completionHandler;

  /// 初期化
  Future<void> initialize() async {
    // Web版はブラウザのSpeechSynthesis APIを使用可能
    // モバイル版は現在スタブ
    _availableVoices = [
      VoiceOption(name: 'Default', locale: 'ja-JP', voiceURI: 'default'),
    ];
  }

  /// 利用可能な音声を取得
  List<VoiceOption> get availableVoices => _availableVoices;

  /// テキストを読み上げ（スタブ - 何もしない）
  Future<void> speak(
    String text, {
    String? voiceURI,
    double speed = 1.0,
  }) async {
    // TODO: Implement when flutter_tts is fixed
    print('TTS (stub): $text');
    _isSpeaking = false;
    _completionHandler?.call();
  }

  /// 読み上げを停止
  Future<void> stop() async {
    _isSpeaking = false;
  }

  /// 読み上げ中かどうか
  bool get isSpeaking => _isSpeaking;

  /// 完了コールバックを設定
  void setCompletionHandler(void Function() onComplete) {
    _completionHandler = onComplete;
  }

  /// エラーコールバックを設定
  void setErrorHandler(void Function(String) onError) {
    // Stub - no-op
  }
}
