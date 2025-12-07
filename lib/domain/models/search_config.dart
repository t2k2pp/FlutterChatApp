import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_config.freezed.dart';
part 'search_config.g.dart';

/// 検索設定を表すモデル
@freezed
class SearchConfig with _$SearchConfig {
  const factory SearchConfig({
    required bool enabled,
    @Default('searxng') String provider,
    required String baseUrl, // 例: http://localhost:8080
    required bool deepResearchEnabled, // デフォルトトグル状態
    @Default(3) int maxIterations, // Deep Research用
  }) = _SearchConfig;

  factory SearchConfig.fromJson(Map<String, dynamic> json) =>
      _$SearchConfigFromJson(json);
}
