// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SearchConfig _$SearchConfigFromJson(Map<String, dynamic> json) {
  return _SearchConfig.fromJson(json);
}

/// @nodoc
mixin _$SearchConfig {
  bool get enabled => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
  String get baseUrl =>
      throw _privateConstructorUsedError; // 例: http://localhost:8080
  bool get deepResearchEnabled =>
      throw _privateConstructorUsedError; // デフォルトトグル状態
  int get maxIterations => throw _privateConstructorUsedError;

  /// Serializes this SearchConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SearchConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchConfigCopyWith<SearchConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchConfigCopyWith<$Res> {
  factory $SearchConfigCopyWith(
          SearchConfig value, $Res Function(SearchConfig) then) =
      _$SearchConfigCopyWithImpl<$Res, SearchConfig>;
  @useResult
  $Res call(
      {bool enabled,
      String provider,
      String baseUrl,
      bool deepResearchEnabled,
      int maxIterations});
}

/// @nodoc
class _$SearchConfigCopyWithImpl<$Res, $Val extends SearchConfig>
    implements $SearchConfigCopyWith<$Res> {
  _$SearchConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? provider = null,
    Object? baseUrl = null,
    Object? deepResearchEnabled = null,
    Object? maxIterations = null,
  }) {
    return _then(_value.copyWith(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      baseUrl: null == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      deepResearchEnabled: null == deepResearchEnabled
          ? _value.deepResearchEnabled
          : deepResearchEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      maxIterations: null == maxIterations
          ? _value.maxIterations
          : maxIterations // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchConfigImplCopyWith<$Res>
    implements $SearchConfigCopyWith<$Res> {
  factory _$$SearchConfigImplCopyWith(
          _$SearchConfigImpl value, $Res Function(_$SearchConfigImpl) then) =
      __$$SearchConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool enabled,
      String provider,
      String baseUrl,
      bool deepResearchEnabled,
      int maxIterations});
}

/// @nodoc
class __$$SearchConfigImplCopyWithImpl<$Res>
    extends _$SearchConfigCopyWithImpl<$Res, _$SearchConfigImpl>
    implements _$$SearchConfigImplCopyWith<$Res> {
  __$$SearchConfigImplCopyWithImpl(
      _$SearchConfigImpl _value, $Res Function(_$SearchConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enabled = null,
    Object? provider = null,
    Object? baseUrl = null,
    Object? deepResearchEnabled = null,
    Object? maxIterations = null,
  }) {
    return _then(_$SearchConfigImpl(
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      baseUrl: null == baseUrl
          ? _value.baseUrl
          : baseUrl // ignore: cast_nullable_to_non_nullable
              as String,
      deepResearchEnabled: null == deepResearchEnabled
          ? _value.deepResearchEnabled
          : deepResearchEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      maxIterations: null == maxIterations
          ? _value.maxIterations
          : maxIterations // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchConfigImpl implements _SearchConfig {
  const _$SearchConfigImpl(
      {required this.enabled,
      this.provider = 'searxng',
      required this.baseUrl,
      required this.deepResearchEnabled,
      this.maxIterations = 3});

  factory _$SearchConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchConfigImplFromJson(json);

  @override
  final bool enabled;
  @override
  @JsonKey()
  final String provider;
  @override
  final String baseUrl;
// 例: http://localhost:8080
  @override
  final bool deepResearchEnabled;
// デフォルトトグル状態
  @override
  @JsonKey()
  final int maxIterations;

  @override
  String toString() {
    return 'SearchConfig(enabled: $enabled, provider: $provider, baseUrl: $baseUrl, deepResearchEnabled: $deepResearchEnabled, maxIterations: $maxIterations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchConfigImpl &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.baseUrl, baseUrl) || other.baseUrl == baseUrl) &&
            (identical(other.deepResearchEnabled, deepResearchEnabled) ||
                other.deepResearchEnabled == deepResearchEnabled) &&
            (identical(other.maxIterations, maxIterations) ||
                other.maxIterations == maxIterations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, enabled, provider, baseUrl,
      deepResearchEnabled, maxIterations);

  /// Create a copy of SearchConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchConfigImplCopyWith<_$SearchConfigImpl> get copyWith =>
      __$$SearchConfigImplCopyWithImpl<_$SearchConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchConfigImplToJson(
      this,
    );
  }
}

abstract class _SearchConfig implements SearchConfig {
  const factory _SearchConfig(
      {required final bool enabled,
      final String provider,
      required final String baseUrl,
      required final bool deepResearchEnabled,
      final int maxIterations}) = _$SearchConfigImpl;

  factory _SearchConfig.fromJson(Map<String, dynamic> json) =
      _$SearchConfigImpl.fromJson;

  @override
  bool get enabled;
  @override
  String get provider;
  @override
  String get baseUrl; // 例: http://localhost:8080
  @override
  bool get deepResearchEnabled; // デフォルトトグル状態
  @override
  int get maxIterations;

  /// Create a copy of SearchConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchConfigImplCopyWith<_$SearchConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
