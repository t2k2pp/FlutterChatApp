// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) {
  return _UserSettings.fromJson(json);
}

/// @nodoc
mixin _$UserSettings {
  List<ModelConfig> get models => throw _privateConstructorUsedError;
  String get activeModelId => throw _privateConstructorUsedError;
  String get subModelId =>
      throw _privateConstructorUsedError; // Watson/Observer Role用
  WatsonInterventionLevel get watsonInterventionLevel =>
      throw _privateConstructorUsedError;
  List<Project> get projects =>
      throw _privateConstructorUsedError; // 保存されたプロジェクト
  SearchConfig get search => throw _privateConstructorUsedError;
  TTSConfig get tts => throw _privateConstructorUsedError;
  bool get timeAwareness => throw _privateConstructorUsedError;

  /// Serializes this UserSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSettingsCopyWith<UserSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingsCopyWith<$Res> {
  factory $UserSettingsCopyWith(
          UserSettings value, $Res Function(UserSettings) then) =
      _$UserSettingsCopyWithImpl<$Res, UserSettings>;
  @useResult
  $Res call(
      {List<ModelConfig> models,
      String activeModelId,
      String subModelId,
      WatsonInterventionLevel watsonInterventionLevel,
      List<Project> projects,
      SearchConfig search,
      TTSConfig tts,
      bool timeAwareness});

  $SearchConfigCopyWith<$Res> get search;
  $TTSConfigCopyWith<$Res> get tts;
}

/// @nodoc
class _$UserSettingsCopyWithImpl<$Res, $Val extends UserSettings>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? models = null,
    Object? activeModelId = null,
    Object? subModelId = null,
    Object? watsonInterventionLevel = null,
    Object? projects = null,
    Object? search = null,
    Object? tts = null,
    Object? timeAwareness = null,
  }) {
    return _then(_value.copyWith(
      models: null == models
          ? _value.models
          : models // ignore: cast_nullable_to_non_nullable
              as List<ModelConfig>,
      activeModelId: null == activeModelId
          ? _value.activeModelId
          : activeModelId // ignore: cast_nullable_to_non_nullable
              as String,
      subModelId: null == subModelId
          ? _value.subModelId
          : subModelId // ignore: cast_nullable_to_non_nullable
              as String,
      watsonInterventionLevel: null == watsonInterventionLevel
          ? _value.watsonInterventionLevel
          : watsonInterventionLevel // ignore: cast_nullable_to_non_nullable
              as WatsonInterventionLevel,
      projects: null == projects
          ? _value.projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Project>,
      search: null == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as SearchConfig,
      tts: null == tts
          ? _value.tts
          : tts // ignore: cast_nullable_to_non_nullable
              as TTSConfig,
      timeAwareness: null == timeAwareness
          ? _value.timeAwareness
          : timeAwareness // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchConfigCopyWith<$Res> get search {
    return $SearchConfigCopyWith<$Res>(_value.search, (value) {
      return _then(_value.copyWith(search: value) as $Val);
    });
  }

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TTSConfigCopyWith<$Res> get tts {
    return $TTSConfigCopyWith<$Res>(_value.tts, (value) {
      return _then(_value.copyWith(tts: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserSettingsImplCopyWith<$Res>
    implements $UserSettingsCopyWith<$Res> {
  factory _$$UserSettingsImplCopyWith(
          _$UserSettingsImpl value, $Res Function(_$UserSettingsImpl) then) =
      __$$UserSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ModelConfig> models,
      String activeModelId,
      String subModelId,
      WatsonInterventionLevel watsonInterventionLevel,
      List<Project> projects,
      SearchConfig search,
      TTSConfig tts,
      bool timeAwareness});

  @override
  $SearchConfigCopyWith<$Res> get search;
  @override
  $TTSConfigCopyWith<$Res> get tts;
}

/// @nodoc
class __$$UserSettingsImplCopyWithImpl<$Res>
    extends _$UserSettingsCopyWithImpl<$Res, _$UserSettingsImpl>
    implements _$$UserSettingsImplCopyWith<$Res> {
  __$$UserSettingsImplCopyWithImpl(
      _$UserSettingsImpl _value, $Res Function(_$UserSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? models = null,
    Object? activeModelId = null,
    Object? subModelId = null,
    Object? watsonInterventionLevel = null,
    Object? projects = null,
    Object? search = null,
    Object? tts = null,
    Object? timeAwareness = null,
  }) {
    return _then(_$UserSettingsImpl(
      models: null == models
          ? _value._models
          : models // ignore: cast_nullable_to_non_nullable
              as List<ModelConfig>,
      activeModelId: null == activeModelId
          ? _value.activeModelId
          : activeModelId // ignore: cast_nullable_to_non_nullable
              as String,
      subModelId: null == subModelId
          ? _value.subModelId
          : subModelId // ignore: cast_nullable_to_non_nullable
              as String,
      watsonInterventionLevel: null == watsonInterventionLevel
          ? _value.watsonInterventionLevel
          : watsonInterventionLevel // ignore: cast_nullable_to_non_nullable
              as WatsonInterventionLevel,
      projects: null == projects
          ? _value._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Project>,
      search: null == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as SearchConfig,
      tts: null == tts
          ? _value.tts
          : tts // ignore: cast_nullable_to_non_nullable
              as TTSConfig,
      timeAwareness: null == timeAwareness
          ? _value.timeAwareness
          : timeAwareness // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSettingsImpl implements _UserSettings {
  const _$UserSettingsImpl(
      {required final List<ModelConfig> models,
      required this.activeModelId,
      required this.subModelId,
      required this.watsonInterventionLevel,
      required final List<Project> projects,
      required this.search,
      required this.tts,
      this.timeAwareness = true})
      : _models = models,
        _projects = projects;

  factory _$UserSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSettingsImplFromJson(json);

  final List<ModelConfig> _models;
  @override
  List<ModelConfig> get models {
    if (_models is EqualUnmodifiableListView) return _models;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_models);
  }

  @override
  final String activeModelId;
  @override
  final String subModelId;
// Watson/Observer Role用
  @override
  final WatsonInterventionLevel watsonInterventionLevel;
  final List<Project> _projects;
  @override
  List<Project> get projects {
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projects);
  }

// 保存されたプロジェクト
  @override
  final SearchConfig search;
  @override
  final TTSConfig tts;
  @override
  @JsonKey()
  final bool timeAwareness;

  @override
  String toString() {
    return 'UserSettings(models: $models, activeModelId: $activeModelId, subModelId: $subModelId, watsonInterventionLevel: $watsonInterventionLevel, projects: $projects, search: $search, tts: $tts, timeAwareness: $timeAwareness)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingsImpl &&
            const DeepCollectionEquality().equals(other._models, _models) &&
            (identical(other.activeModelId, activeModelId) ||
                other.activeModelId == activeModelId) &&
            (identical(other.subModelId, subModelId) ||
                other.subModelId == subModelId) &&
            (identical(
                    other.watsonInterventionLevel, watsonInterventionLevel) ||
                other.watsonInterventionLevel == watsonInterventionLevel) &&
            const DeepCollectionEquality().equals(other._projects, _projects) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.tts, tts) || other.tts == tts) &&
            (identical(other.timeAwareness, timeAwareness) ||
                other.timeAwareness == timeAwareness));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_models),
      activeModelId,
      subModelId,
      watsonInterventionLevel,
      const DeepCollectionEquality().hash(_projects),
      search,
      tts,
      timeAwareness);

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      __$$UserSettingsImplCopyWithImpl<_$UserSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSettingsImplToJson(
      this,
    );
  }
}

abstract class _UserSettings implements UserSettings {
  const factory _UserSettings(
      {required final List<ModelConfig> models,
      required final String activeModelId,
      required final String subModelId,
      required final WatsonInterventionLevel watsonInterventionLevel,
      required final List<Project> projects,
      required final SearchConfig search,
      required final TTSConfig tts,
      final bool timeAwareness}) = _$UserSettingsImpl;

  factory _UserSettings.fromJson(Map<String, dynamic> json) =
      _$UserSettingsImpl.fromJson;

  @override
  List<ModelConfig> get models;
  @override
  String get activeModelId;
  @override
  String get subModelId; // Watson/Observer Role用
  @override
  WatsonInterventionLevel get watsonInterventionLevel;
  @override
  List<Project> get projects; // 保存されたプロジェクト
  @override
  SearchConfig get search;
  @override
  TTSConfig get tts;
  @override
  bool get timeAwareness;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
