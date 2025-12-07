// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageImage _$MessageImageFromJson(Map<String, dynamic> json) {
  return _MessageImage.fromJson(json);
}

/// @nodoc
mixin _$MessageImage {
  String get base64 => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;

  /// Serializes this MessageImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageImageCopyWith<MessageImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageImageCopyWith<$Res> {
  factory $MessageImageCopyWith(
          MessageImage value, $Res Function(MessageImage) then) =
      _$MessageImageCopyWithImpl<$Res, MessageImage>;
  @useResult
  $Res call({String base64, String mimeType});
}

/// @nodoc
class _$MessageImageCopyWithImpl<$Res, $Val extends MessageImage>
    implements $MessageImageCopyWith<$Res> {
  _$MessageImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? base64 = null,
    Object? mimeType = null,
  }) {
    return _then(_value.copyWith(
      base64: null == base64
          ? _value.base64
          : base64 // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageImageImplCopyWith<$Res>
    implements $MessageImageCopyWith<$Res> {
  factory _$$MessageImageImplCopyWith(
          _$MessageImageImpl value, $Res Function(_$MessageImageImpl) then) =
      __$$MessageImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String base64, String mimeType});
}

/// @nodoc
class __$$MessageImageImplCopyWithImpl<$Res>
    extends _$MessageImageCopyWithImpl<$Res, _$MessageImageImpl>
    implements _$$MessageImageImplCopyWith<$Res> {
  __$$MessageImageImplCopyWithImpl(
      _$MessageImageImpl _value, $Res Function(_$MessageImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? base64 = null,
    Object? mimeType = null,
  }) {
    return _then(_$MessageImageImpl(
      base64: null == base64
          ? _value.base64
          : base64 // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageImageImpl implements _MessageImage {
  const _$MessageImageImpl({required this.base64, required this.mimeType});

  factory _$MessageImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageImageImplFromJson(json);

  @override
  final String base64;
  @override
  final String mimeType;

  @override
  String toString() {
    return 'MessageImage(base64: $base64, mimeType: $mimeType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImageImpl &&
            (identical(other.base64, base64) || other.base64 == base64) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, base64, mimeType);

  /// Create a copy of MessageImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImageImplCopyWith<_$MessageImageImpl> get copyWith =>
      __$$MessageImageImplCopyWithImpl<_$MessageImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageImageImplToJson(
      this,
    );
  }
}

abstract class _MessageImage implements MessageImage {
  const factory _MessageImage(
      {required final String base64,
      required final String mimeType}) = _$MessageImageImpl;

  factory _MessageImage.fromJson(Map<String, dynamic> json) =
      _$MessageImageImpl.fromJson;

  @override
  String get base64;
  @override
  String get mimeType;

  /// Create a copy of MessageImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageImageImplCopyWith<_$MessageImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
