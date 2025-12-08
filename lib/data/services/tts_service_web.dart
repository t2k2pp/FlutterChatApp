// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'tts_service.dart';

/// Web用TTS実装（Web Speech API使用）
Future<List<VoiceOption>> getAvailableVoices() async {
  final synth = html.window.speechSynthesis;
  if (synth == null) {
    return [VoiceOption(name: 'Default', locale: 'ja-JP', voiceURI: 'default')];
  }
  
  // 音声リストが読み込まれるまで待機
  var voices = synth.getVoices();
  if (voices.isEmpty) {
    await Future.delayed(const Duration(milliseconds: 100));
    voices = synth.getVoices();
  }
  
  return voices.map((v) => VoiceOption(
    name: v.name,
    locale: v.lang,
    voiceURI: v.voiceUri,
  )).toList();
}

Future<void> speak(String text, {String? voiceURI, double speed = 1.0}) async {
  final synth = html.window.speechSynthesis;
  if (synth == null) return;
  
  // 現在の読み上げを停止
  synth.cancel();
  
  // 新しい発話を作成
  final utterance = html.SpeechSynthesisUtterance(text);
  utterance.rate = speed;
  utterance.lang = 'ja-JP';
  
  // 音声を設定
  if (voiceURI != null) {
    final voices = synth.getVoices();
    final voice = voices.firstWhere(
      (v) => v.voiceUri == voiceURI,
      orElse: () => voices.first,
    );
    utterance.voice = voice;
  }
  
  synth.speak(utterance);
}

Future<void> stop() async {
  final synth = html.window.speechSynthesis;
  synth?.cancel();
}
