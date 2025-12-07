import 'package:freezed_annotation/freezed_annotation.dart';

part 'tts_config.freezed.dart';
part 'tts_config.g.dart';

/// TTS設定を表すモデル
@freezed
class TTSConfig with _$TTSConfig {
  const factory TTSConfig({
    String? voiceURI, // 選択された音声の一意ID
    @Default(1.0) double speed, // 0.5 から 2.0
  }) = _TTSConfig;

  factory TTSConfig.fromJson(Map<String, dynamic> json) =>
      _$TTSConfigFromJson(json);
}
