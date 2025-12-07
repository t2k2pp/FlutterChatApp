// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model_usage_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ModelUsageStats _$ModelUsageStatsFromJson(Map<String, dynamic> json) {
  return _ModelUsageStats.fromJson(json);
}

/// @nodoc
mixin _$ModelUsageStats {
  String get modelId => throw _privateConstructorUsedError;
  int get totalPromptTokens => throw _privateConstructorUsedError;
  int get totalCompletionTokens => throw _privateConstructorUsedError;
  int get totalTokens => throw _privateConstructorUsedError;

  /// Serializes this ModelUsageStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ModelUsageStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModelUsageStatsCopyWith<ModelUsageStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModelUsageStatsCopyWith<$Res> {
  factory $ModelUsageStatsCopyWith(
          ModelUsageStats value, $Res Function(ModelUsageStats) then) =
      _$ModelUsageStatsCopyWithImpl<$Res, ModelUsageStats>;
  @useResult
  $Res call(
      {String modelId,
      int totalPromptTokens,
      int totalCompletionTokens,
      int totalTokens});
}

/// @nodoc
class _$ModelUsageStatsCopyWithImpl<$Res, $Val extends ModelUsageStats>
    implements $ModelUsageStatsCopyWith<$Res> {
  _$ModelUsageStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModelUsageStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modelId = null,
    Object? totalPromptTokens = null,
    Object? totalCompletionTokens = null,
    Object? totalTokens = null,
  }) {
    return _then(_value.copyWith(
      modelId: null == modelId
          ? _value.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String,
      totalPromptTokens: null == totalPromptTokens
          ? _value.totalPromptTokens
          : totalPromptTokens // ignore: cast_nullable_to_non_nullable
              as int,
      totalCompletionTokens: null == totalCompletionTokens
          ? _value.totalCompletionTokens
          : totalCompletionTokens // ignore: cast_nullable_to_non_nullable
              as int,
      totalTokens: null == totalTokens
          ? _value.totalTokens
          : totalTokens // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModelUsageStatsImplCopyWith<$Res>
    implements $ModelUsageStatsCopyWith<$Res> {
  factory _$$ModelUsageStatsImplCopyWith(_$ModelUsageStatsImpl value,
          $Res Function(_$ModelUsageStatsImpl) then) =
      __$$ModelUsageStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String modelId,
      int totalPromptTokens,
      int totalCompletionTokens,
      int totalTokens});
}

/// @nodoc
class __$$ModelUsageStatsImplCopyWithImpl<$Res>
    extends _$ModelUsageStatsCopyWithImpl<$Res, _$ModelUsageStatsImpl>
    implements _$$ModelUsageStatsImplCopyWith<$Res> {
  __$$ModelUsageStatsImplCopyWithImpl(
      _$ModelUsageStatsImpl _value, $Res Function(_$ModelUsageStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ModelUsageStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modelId = null,
    Object? totalPromptTokens = null,
    Object? totalCompletionTokens = null,
    Object? totalTokens = null,
  }) {
    return _then(_$ModelUsageStatsImpl(
      modelId: null == modelId
          ? _value.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String,
      totalPromptTokens: null == totalPromptTokens
          ? _value.totalPromptTokens
          : totalPromptTokens // ignore: cast_nullable_to_non_nullable
              as int,
      totalCompletionTokens: null == totalCompletionTokens
          ? _value.totalCompletionTokens
          : totalCompletionTokens // ignore: cast_nullable_to_non_nullable
              as int,
      totalTokens: null == totalTokens
          ? _value.totalTokens
          : totalTokens // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ModelUsageStatsImpl implements _ModelUsageStats {
  const _$ModelUsageStatsImpl(
      {required this.modelId,
      this.totalPromptTokens = 0,
      this.totalCompletionTokens = 0,
      this.totalTokens = 0});

  factory _$ModelUsageStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModelUsageStatsImplFromJson(json);

  @override
  final String modelId;
  @override
  @JsonKey()
  final int totalPromptTokens;
  @override
  @JsonKey()
  final int totalCompletionTokens;
  @override
  @JsonKey()
  final int totalTokens;

  @override
  String toString() {
    return 'ModelUsageStats(modelId: $modelId, totalPromptTokens: $totalPromptTokens, totalCompletionTokens: $totalCompletionTokens, totalTokens: $totalTokens)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModelUsageStatsImpl &&
            (identical(other.modelId, modelId) || other.modelId == modelId) &&
            (identical(other.totalPromptTokens, totalPromptTokens) ||
                other.totalPromptTokens == totalPromptTokens) &&
            (identical(other.totalCompletionTokens, totalCompletionTokens) ||
                other.totalCompletionTokens == totalCompletionTokens) &&
            (identical(other.totalTokens, totalTokens) ||
                other.totalTokens == totalTokens));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, modelId, totalPromptTokens,
      totalCompletionTokens, totalTokens);

  /// Create a copy of ModelUsageStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModelUsageStatsImplCopyWith<_$ModelUsageStatsImpl> get copyWith =>
      __$$ModelUsageStatsImplCopyWithImpl<_$ModelUsageStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModelUsageStatsImplToJson(
      this,
    );
  }
}

abstract class _ModelUsageStats implements ModelUsageStats {
  const factory _ModelUsageStats(
      {required final String modelId,
      final int totalPromptTokens,
      final int totalCompletionTokens,
      final int totalTokens}) = _$ModelUsageStatsImpl;

  factory _ModelUsageStats.fromJson(Map<String, dynamic> json) =
      _$ModelUsageStatsImpl.fromJson;

  @override
  String get modelId;
  @override
  int get totalPromptTokens;
  @override
  int get totalCompletionTokens;
  @override
  int get totalTokens;

  /// Create a copy of ModelUsageStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModelUsageStatsImplCopyWith<_$ModelUsageStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
