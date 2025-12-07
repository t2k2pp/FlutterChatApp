// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reasoning_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReasoningStep _$ReasoningStepFromJson(Map<String, dynamic> json) {
  return _ReasoningStep.fromJson(json);
}

/// @nodoc
mixin _$ReasoningStep {
  ReasoningType get type => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError;

  /// Serializes this ReasoningStep to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReasoningStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReasoningStepCopyWith<ReasoningStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReasoningStepCopyWith<$Res> {
  factory $ReasoningStepCopyWith(
          ReasoningStep value, $Res Function(ReasoningStep) then) =
      _$ReasoningStepCopyWithImpl<$Res, ReasoningStep>;
  @useResult
  $Res call({ReasoningType type, String content, int timestamp});
}

/// @nodoc
class _$ReasoningStepCopyWithImpl<$Res, $Val extends ReasoningStep>
    implements $ReasoningStepCopyWith<$Res> {
  _$ReasoningStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReasoningStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? content = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReasoningType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReasoningStepImplCopyWith<$Res>
    implements $ReasoningStepCopyWith<$Res> {
  factory _$$ReasoningStepImplCopyWith(
          _$ReasoningStepImpl value, $Res Function(_$ReasoningStepImpl) then) =
      __$$ReasoningStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ReasoningType type, String content, int timestamp});
}

/// @nodoc
class __$$ReasoningStepImplCopyWithImpl<$Res>
    extends _$ReasoningStepCopyWithImpl<$Res, _$ReasoningStepImpl>
    implements _$$ReasoningStepImplCopyWith<$Res> {
  __$$ReasoningStepImplCopyWithImpl(
      _$ReasoningStepImpl _value, $Res Function(_$ReasoningStepImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReasoningStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? content = null,
    Object? timestamp = null,
  }) {
    return _then(_$ReasoningStepImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ReasoningType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReasoningStepImpl implements _ReasoningStep {
  const _$ReasoningStepImpl(
      {required this.type, required this.content, required this.timestamp});

  factory _$ReasoningStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReasoningStepImplFromJson(json);

  @override
  final ReasoningType type;
  @override
  final String content;
  @override
  final int timestamp;

  @override
  String toString() {
    return 'ReasoningStep(type: $type, content: $content, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReasoningStepImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, content, timestamp);

  /// Create a copy of ReasoningStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReasoningStepImplCopyWith<_$ReasoningStepImpl> get copyWith =>
      __$$ReasoningStepImplCopyWithImpl<_$ReasoningStepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReasoningStepImplToJson(
      this,
    );
  }
}

abstract class _ReasoningStep implements ReasoningStep {
  const factory _ReasoningStep(
      {required final ReasoningType type,
      required final String content,
      required final int timestamp}) = _$ReasoningStepImpl;

  factory _ReasoningStep.fromJson(Map<String, dynamic> json) =
      _$ReasoningStepImpl.fromJson;

  @override
  ReasoningType get type;
  @override
  String get content;
  @override
  int get timestamp;

  /// Create a copy of ReasoningStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReasoningStepImplCopyWith<_$ReasoningStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
