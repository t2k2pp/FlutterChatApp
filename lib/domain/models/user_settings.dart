import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_chat_app/domain/models/model_config.dart';
import 'package:flutter_chat_app/domain/models/project.dart';
import 'package:flutter_chat_app/domain/models/search_config.dart';
import 'package:flutter_chat_app/domain/models/tts_config.dart';
import 'package:flutter_chat_app/domain/enums/watson_intervention_level.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

/// ユーザー設定を表すモデル
@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({
    required List<ModelConfig> models,
    required String activeModelId,
    required String subModelId, // Watson/Observer Role用
    required WatsonInterventionLevel watsonInterventionLevel,
    required List<Project> projects, // 保存されたプロジェクト
    required SearchConfig search,
    required TTSConfig tts,
    @Default(true) bool timeAwareness, // スマート日付挿入
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}
