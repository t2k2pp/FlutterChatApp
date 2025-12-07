// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Message _$MessageFromJson(Map<String, dynamic> json) {
  return _Message.fromJson(json);
}

/// @nodoc
mixin _$Message {
  String get id => throw _privateConstructorUsedError;
  Role get role => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError;
  bool get isError => throw _privateConstructorUsedError;
  List<ReasoningStep>? get reasoningLogs =>
      throw _privateConstructorUsedError; // Deep Researchの可視性用
  bool get includedInContext =>
      throw _privateConstructorUsedError; // メインAIに表示されるか
  bool? get watsonChecked =>
      throw _privateConstructorUsedError; // Watsonが確認して介入しなかった場合 true
  TokenUsage? get usage =>
      throw _privateConstructorUsedError; // このメッセージ生成のトークン使用量
  List<MessageImage>? get images => throw _privateConstructorUsedError;

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call(
      {String id,
      Role role,
      String text,
      int timestamp,
      bool isError,
      List<ReasoningStep>? reasoningLogs,
      bool includedInContext,
      bool? watsonChecked,
      TokenUsage? usage,
      List<MessageImage>? images});

  $TokenUsageCopyWith<$Res>? get usage;
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? text = null,
    Object? timestamp = null,
    Object? isError = null,
    Object? reasoningLogs = freezed,
    Object? includedInContext = null,
    Object? watsonChecked = freezed,
    Object? usage = freezed,
    Object? images = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as Role,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
      reasoningLogs: freezed == reasoningLogs
          ? _value.reasoningLogs
          : reasoningLogs // ignore: cast_nullable_to_non_nullable
              as List<ReasoningStep>?,
      includedInContext: null == includedInContext
          ? _value.includedInContext
          : includedInContext // ignore: cast_nullable_to_non_nullable
              as bool,
      watsonChecked: freezed == watsonChecked
          ? _value.watsonChecked
          : watsonChecked // ignore: cast_nullable_to_non_nullable
              as bool?,
      usage: freezed == usage
          ? _value.usage
          : usage // ignore: cast_nullable_to_non_nullable
              as TokenUsage?,
      images: freezed == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<MessageImage>?,
    ) as $Val);
  }

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TokenUsageCopyWith<$Res>? get usage {
    if (_value.usage == null) {
      return null;
    }

    return $TokenUsageCopyWith<$Res>(_value.usage!, (value) {
      return _then(_value.copyWith(usage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
          _$MessageImpl value, $Res Function(_$MessageImpl) then) =
      __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      Role role,
      String text,
      int timestamp,
      bool isError,
      List<ReasoningStep>? reasoningLogs,
      bool includedInContext,
      bool? watsonChecked,
      TokenUsage? usage,
      List<MessageImage>? images});

  @override
  $TokenUsageCopyWith<$Res>? get usage;
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
      _$MessageImpl _value, $Res Function(_$MessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? text = null,
    Object? timestamp = null,
    Object? isError = null,
    Object? reasoningLogs = freezed,
    Object? includedInContext = null,
    Object? watsonChecked = freezed,
    Object? usage = freezed,
    Object? images = freezed,
  }) {
    return _then(_$MessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as Role,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
      reasoningLogs: freezed == reasoningLogs
          ? _value._reasoningLogs
          : reasoningLogs // ignore: cast_nullable_to_non_nullable
              as List<ReasoningStep>?,
      includedInContext: null == includedInContext
          ? _value.includedInContext
          : includedInContext // ignore: cast_nullable_to_non_nullable
              as bool,
      watsonChecked: freezed == watsonChecked
          ? _value.watsonChecked
          : watsonChecked // ignore: cast_nullable_to_non_nullable
              as bool?,
      usage: freezed == usage
          ? _value.usage
          : usage // ignore: cast_nullable_to_non_nullable
              as TokenUsage?,
      images: freezed == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<MessageImage>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageImpl implements _Message {
  const _$MessageImpl(
      {required this.id,
      required this.role,
      required this.text,
      required this.timestamp,
      this.isError = false,
      final List<ReasoningStep>? reasoningLogs,
      this.includedInContext = true,
      this.watsonChecked,
      this.usage,
      final List<MessageImage>? images})
      : _reasoningLogs = reasoningLogs,
        _images = images;

  factory _$MessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageImplFromJson(json);

  @override
  final String id;
  @override
  final Role role;
  @override
  final String text;
  @override
  final int timestamp;
  @override
  @JsonKey()
  final bool isError;
  final List<ReasoningStep>? _reasoningLogs;
  @override
  List<ReasoningStep>? get reasoningLogs {
    final value = _reasoningLogs;
    if (value == null) return null;
    if (_reasoningLogs is EqualUnmodifiableListView) return _reasoningLogs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Deep Researchの可視性用
  @override
  @JsonKey()
  final bool includedInContext;
// メインAIに表示されるか
  @override
  final bool? watsonChecked;
// Watsonが確認して介入しなかった場合 true
  @override
  final TokenUsage? usage;
// このメッセージ生成のトークン使用量
  final List<MessageImage>? _images;
// このメッセージ生成のトークン使用量
  @override
  List<MessageImage>? get images {
    final value = _images;
    if (value == null) return null;
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Message(id: $id, role: $role, text: $text, timestamp: $timestamp, isError: $isError, reasoningLogs: $reasoningLogs, includedInContext: $includedInContext, watsonChecked: $watsonChecked, usage: $usage, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isError, isError) || other.isError == isError) &&
            const DeepCollectionEquality()
                .equals(other._reasoningLogs, _reasoningLogs) &&
            (identical(other.includedInContext, includedInContext) ||
                other.includedInContext == includedInContext) &&
            (identical(other.watsonChecked, watsonChecked) ||
                other.watsonChecked == watsonChecked) &&
            (identical(other.usage, usage) || other.usage == usage) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      role,
      text,
      timestamp,
      isError,
      const DeepCollectionEquality().hash(_reasoningLogs),
      includedInContext,
      watsonChecked,
      usage,
      const DeepCollectionEquality().hash(_images));

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageImplToJson(
      this,
    );
  }
}

abstract class _Message implements Message {
  const factory _Message(
      {required final String id,
      required final Role role,
      required final String text,
      required final int timestamp,
      final bool isError,
      final List<ReasoningStep>? reasoningLogs,
      final bool includedInContext,
      final bool? watsonChecked,
      final TokenUsage? usage,
      final List<MessageImage>? images}) = _$MessageImpl;

  factory _Message.fromJson(Map<String, dynamic> json) = _$MessageImpl.fromJson;

  @override
  String get id;
  @override
  Role get role;
  @override
  String get text;
  @override
  int get timestamp;
  @override
  bool get isError;
  @override
  List<ReasoningStep>? get reasoningLogs; // Deep Researchの可視性用
  @override
  bool get includedInContext; // メインAIに表示されるか
  @override
  bool? get watsonChecked; // Watsonが確認して介入しなかった場合 true
  @override
  TokenUsage? get usage; // このメッセージ生成のトークン使用量
  @override
  List<MessageImage>? get images;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
