// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tts_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TTSConfig _$TTSConfigFromJson(Map<String, dynamic> json) {
  return _TTSConfig.fromJson(json);
}

/// @nodoc
mixin _$TTSConfig {
  String? get voiceURI => throw _privateConstructorUsedError; // 選択された音声の一意ID
  double get speed => throw _privateConstructorUsedError;

  /// Serializes this TTSConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TTSConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TTSConfigCopyWith<TTSConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TTSConfigCopyWith<$Res> {
  factory $TTSConfigCopyWith(TTSConfig value, $Res Function(TTSConfig) then) =
      _$TTSConfigCopyWithImpl<$Res, TTSConfig>;
  @useResult
  $Res call({String? voiceURI, double speed});
}

/// @nodoc
class _$TTSConfigCopyWithImpl<$Res, $Val extends TTSConfig>
    implements $TTSConfigCopyWith<$Res> {
  _$TTSConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TTSConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? voiceURI = freezed,
    Object? speed = null,
  }) {
    return _then(_value.copyWith(
      voiceURI: freezed == voiceURI
          ? _value.voiceURI
          : voiceURI // ignore: cast_nullable_to_non_nullable
              as String?,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TTSConfigImplCopyWith<$Res>
    implements $TTSConfigCopyWith<$Res> {
  factory _$$TTSConfigImplCopyWith(
          _$TTSConfigImpl value, $Res Function(_$TTSConfigImpl) then) =
      __$$TTSConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? voiceURI, double speed});
}

/// @nodoc
class __$$TTSConfigImplCopyWithImpl<$Res>
    extends _$TTSConfigCopyWithImpl<$Res, _$TTSConfigImpl>
    implements _$$TTSConfigImplCopyWith<$Res> {
  __$$TTSConfigImplCopyWithImpl(
      _$TTSConfigImpl _value, $Res Function(_$TTSConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of TTSConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? voiceURI = freezed,
    Object? speed = null,
  }) {
    return _then(_$TTSConfigImpl(
      voiceURI: freezed == voiceURI
          ? _value.voiceURI
          : voiceURI // ignore: cast_nullable_to_non_nullable
              as String?,
      speed: null == speed
          ? _value.speed
          : speed // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TTSConfigImpl implements _TTSConfig {
  const _$TTSConfigImpl({this.voiceURI, this.speed = 1.0});

  factory _$TTSConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$TTSConfigImplFromJson(json);

  @override
  final String? voiceURI;
// 選択された音声の一意ID
  @override
  @JsonKey()
  final double speed;

  @override
  String toString() {
    return 'TTSConfig(voiceURI: $voiceURI, speed: $speed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TTSConfigImpl &&
            (identical(other.voiceURI, voiceURI) ||
                other.voiceURI == voiceURI) &&
            (identical(other.speed, speed) || other.speed == speed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, voiceURI, speed);

  /// Create a copy of TTSConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TTSConfigImplCopyWith<_$TTSConfigImpl> get copyWith =>
      __$$TTSConfigImplCopyWithImpl<_$TTSConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TTSConfigImplToJson(
      this,
    );
  }
}

abstract class _TTSConfig implements TTSConfig {
  const factory _TTSConfig({final String? voiceURI, final double speed}) =
      _$TTSConfigImpl;

  factory _TTSConfig.fromJson(Map<String, dynamic> json) =
      _$TTSConfigImpl.fromJson;

  @override
  String? get voiceURI; // 選択された音声の一意ID
  @override
  double get speed;

  /// Create a copy of TTSConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TTSConfigImplCopyWith<_$TTSConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
