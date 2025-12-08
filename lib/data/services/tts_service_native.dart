import 'tts_service.dart';

// TODO: flutter_ttsがAndroid 16対応したら有効化
// import 'package:flutter_tts/flutter_tts.dart';

/// ネイティブ（Android/iOS）用TTS実装
/// 現在はflutter_ttsがAndroid 16非対応のため、スタブ実装
Future<List<VoiceOption>> getAvailableVoices() async {
  // TODO: flutter_tts対応後に実装
  return [VoiceOption(name: 'Default', locale: 'ja-JP', voiceURI: 'default')];
}

Future<void> speak(String text, {String? voiceURI, double speed = 1.0}) async {
  // TODO: flutter_tts対応後に実装
  print('TTS (Android stub): $text');
}

Future<void> stop() async {
  // TODO: flutter_tts対応後に実装
}

/*
// flutter_tts対応後の実装例:
final FlutterTts _flutterTts = FlutterTts();

Future<List<VoiceOption>> getAvailableVoices() async {
  final voices = await _flutterTts.getVoices as List;
  return voices.map((v) => VoiceOption(
    name: v['name'] ?? 'Unknown',
    locale: v['locale'] ?? 'ja-JP',
    voiceURI: v['name'],
  )).toList();
}

Future<void> speak(String text, {String? voiceURI, double speed = 1.0}) async {
  await _flutterTts.setLanguage('ja-JP');
  await _flutterTts.setSpeechRate(speed);
  if (voiceURI != null) {
    await _flutterTts.setVoice({'name': voiceURI, 'locale': 'ja-JP'});
  }
  await _flutterTts.speak(text);
}

Future<void> stop() async {
  await _flutterTts.stop();
}
*/
