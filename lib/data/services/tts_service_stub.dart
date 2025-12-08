import 'tts_service.dart';

/// スタブ実装（コンパイル用）
Future<List<VoiceOption>> getAvailableVoices() async {
  return [VoiceOption(name: 'Default', locale: 'ja-JP', voiceURI: 'default')];
}

Future<void> speak(String text, {String? voiceURI, double speed = 1.0}) async {
  // No-op
}

Future<void> stop() async {
  // No-op
}
