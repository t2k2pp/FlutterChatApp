// プラットフォーム固有の実装
import 'tts_service_stub.dart'
    if (dart.library.io) 'tts_service_native.dart'
    if (dart.library.html) 'tts_service_web.dart' as platform;

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

/// TTSサービス
class TTSService {
  List<VoiceOption> _availableVoices = [];
  bool _isSpeaking = false;
  void Function()? _completionHandler;
  void Function(String)? _errorHandler;

  /// 初期化
  Future<void> initialize() async {
    _availableVoices = await platform.getAvailableVoices();
  }

  /// 利用可能な音声を取得
  List<VoiceOption> get availableVoices => _availableVoices;

  /// テキストを読み上げ
  Future<void> speak(
    String text, {
    String? voiceURI,
    double speed = 1.0,
  }) async {
    _isSpeaking = true;
    try {
      await platform.speak(text, voiceURI: voiceURI, speed: speed);
      _completionHandler?.call();
    } catch (e) {
      _errorHandler?.call(e.toString());
    } finally {
      _isSpeaking = false;
    }
  }

  /// 読み上げを停止
  Future<void> stop() async {
    await platform.stop();
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
    _errorHandler = onError;
  }
}
