import 'package:flutter_tts/flutter_tts.dart';

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
  final FlutterTts _tts = FlutterTts();
  List<VoiceOption> _availableVoices = [];
  bool _isSpeaking = false;

  /// 初期化
  Future<void> initialize() async {
    await _loadVoices();
  }

  /// 利用可能な音声を読み込み
  Future<void> _loadVoices() async {
    try {
      final voices = await _tts.getVoices;
      if (voices != null) {
        _availableVoices = (voices as List).map((voice) {
          return VoiceOption(
            name: voice['name'] ?? 'Unknown',
            locale: voice['locale'] ?? 'en-US',
            voiceURI: voice['name'],
          );
        }).toList();
      }
    } catch (e) {
      print('音声読み込みエラー: $e');
    }
  }

  /// 利用可能な音声を取得
  List<VoiceOption> get availableVoices => _availableVoices;

  /// テキストを読み上げ
  Future<void> speak(
    String text, {
    String? voiceURI,
    double speed = 1.0,
  }) async {
    try {
      // 音声を設定
      if (voiceURI != null) {
        await _tts.setVoice({'name': voiceURI, 'locale': 'ja-JP'});
      }

      // 速度を設定
      await _tts.setSpeechRate(speed);

      _isSpeaking = true;
      await _tts.speak(text);
    } catch (e) {
      print('TTSエラー: $e');
      _isSpeaking = false;
    }
  }

  /// 読み上げを停止
  Future<void> stop() async {
    await _tts.stop();
    _isSpeaking = false;
  }

  /// 読み上げ中かどうか
  bool get isSpeaking => _isSpeaking;

  /// 完了コールバックを設定
  void setCompletionHandler(void Function() onComplete) {
    _tts.setCompletionHandler(() {
      _isSpeaking = false;
      onComplete();
    });
  }

  /// エラーコールバックを設定
  void setErrorHandler(void Function(String) onError) {
    _tts.setErrorHandler((msg) {
      _isSpeaking = false;
      onError(msg);
    });
  }
}
