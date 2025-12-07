// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ModelConfig _$ModelConfigFromJson(Map<String, dynamic> json) {
  return _ModelConfig.fromJson(json);
}

/// @nodoc
mixin _$ModelConfig {
  String get id => throw _privateConstructorUsedError;
  String get name =>
      throw _privateConstructorUsedError; // ユーザーフレンドリーな名前（例："My Creative Gemini"）
  AIProvider get provider => throw _privateConstructorUsedError;
  String get modelId =>
      throw _privateConstructorUsedError; // モデル識別子（例："gemini-2.5-flash", "gpt-4", "llama3"）
// 接続詳細
  String? get apiKey => throw _privateConstructorUsedError;
  String? get endpoint => throw _privateConstructorUsedError; // Azure/Local用
  String? get deployment => throw _privateConstructorUsedError; // Azure固有
// パラメーター
  String get systemInstruction => throw _privateConstructorUsedError;
  double get temperature => throw _privateConstructorUsedError;
  double get topP => throw _privateConstructorUsedError;
  int get topK => throw _privateConstructorUsedError; // 機能
  List<String> get capabilities => throw _privateConstructorUsedError;

  /// Serializes this ModelConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ModelConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModelConfigCopyWith<ModelConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModelConfigCopyWith<$Res> {
  factory $ModelConfigCopyWith(
          ModelConfig value, $Res Function(ModelConfig) then) =
      _$ModelConfigCopyWithImpl<$Res, ModelConfig>;
  @useResult
  $Res call(
      {String id,
      String name,
      AIProvider provider,
      String modelId,
      String? apiKey,
      String? endpoint,
      String? deployment,
      String systemInstruction,
      double temperature,
      double topP,
      int topK,
      List<String> capabilities});
}

/// @nodoc
class _$ModelConfigCopyWithImpl<$Res, $Val extends ModelConfig>
    implements $ModelConfigCopyWith<$Res> {
  _$ModelConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModelConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? provider = null,
    Object? modelId = null,
    Object? apiKey = freezed,
    Object? endpoint = freezed,
    Object? deployment = freezed,
    Object? systemInstruction = null,
    Object? temperature = null,
    Object? topP = null,
    Object? topK = null,
    Object? capabilities = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as AIProvider,
      modelId: null == modelId
          ? _value.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String,
      apiKey: freezed == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      endpoint: freezed == endpoint
          ? _value.endpoint
          : endpoint // ignore: cast_nullable_to_non_nullable
              as String?,
      deployment: freezed == deployment
          ? _value.deployment
          : deployment // ignore: cast_nullable_to_non_nullable
              as String?,
      systemInstruction: null == systemInstruction
          ? _value.systemInstruction
          : systemInstruction // ignore: cast_nullable_to_non_nullable
              as String,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      topP: null == topP
          ? _value.topP
          : topP // ignore: cast_nullable_to_non_nullable
              as double,
      topK: null == topK
          ? _value.topK
          : topK // ignore: cast_nullable_to_non_nullable
              as int,
      capabilities: null == capabilities
          ? _value.capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModelConfigImplCopyWith<$Res>
    implements $ModelConfigCopyWith<$Res> {
  factory _$$ModelConfigImplCopyWith(
          _$ModelConfigImpl value, $Res Function(_$ModelConfigImpl) then) =
      __$$ModelConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      AIProvider provider,
      String modelId,
      String? apiKey,
      String? endpoint,
      String? deployment,
      String systemInstruction,
      double temperature,
      double topP,
      int topK,
      List<String> capabilities});
}

/// @nodoc
class __$$ModelConfigImplCopyWithImpl<$Res>
    extends _$ModelConfigCopyWithImpl<$Res, _$ModelConfigImpl>
    implements _$$ModelConfigImplCopyWith<$Res> {
  __$$ModelConfigImplCopyWithImpl(
      _$ModelConfigImpl _value, $Res Function(_$ModelConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of ModelConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? provider = null,
    Object? modelId = null,
    Object? apiKey = freezed,
    Object? endpoint = freezed,
    Object? deployment = freezed,
    Object? systemInstruction = null,
    Object? temperature = null,
    Object? topP = null,
    Object? topK = null,
    Object? capabilities = null,
  }) {
    return _then(_$ModelConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as AIProvider,
      modelId: null == modelId
          ? _value.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String,
      apiKey: freezed == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      endpoint: freezed == endpoint
          ? _value.endpoint
          : endpoint // ignore: cast_nullable_to_non_nullable
              as String?,
      deployment: freezed == deployment
          ? _value.deployment
          : deployment // ignore: cast_nullable_to_non_nullable
              as String?,
      systemInstruction: null == systemInstruction
          ? _value.systemInstruction
          : systemInstruction // ignore: cast_nullable_to_non_nullable
              as String,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      topP: null == topP
          ? _value.topP
          : topP // ignore: cast_nullable_to_non_nullable
              as double,
      topK: null == topK
          ? _value.topK
          : topK // ignore: cast_nullable_to_non_nullable
              as int,
      capabilities: null == capabilities
          ? _value._capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ModelConfigImpl implements _ModelConfig {
  const _$ModelConfigImpl(
      {required this.id,
      required this.name,
      required this.provider,
      required this.modelId,
      this.apiKey,
      this.endpoint,
      this.deployment,
      required this.systemInstruction,
      required this.temperature,
      required this.topP,
      required this.topK,
      final List<String> capabilities = const []})
      : _capabilities = capabilities;

  factory _$ModelConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModelConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
// ユーザーフレンドリーな名前（例："My Creative Gemini"）
  @override
  final AIProvider provider;
  @override
  final String modelId;
// モデル識別子（例："gemini-2.5-flash", "gpt-4", "llama3"）
// 接続詳細
  @override
  final String? apiKey;
  @override
  final String? endpoint;
// Azure/Local用
  @override
  final String? deployment;
// Azure固有
// パラメーター
  @override
  final String systemInstruction;
  @override
  final double temperature;
  @override
  final double topP;
  @override
  final int topK;
// 機能
  final List<String> _capabilities;
// 機能
  @override
  @JsonKey()
  List<String> get capabilities {
    if (_capabilities is EqualUnmodifiableListView) return _capabilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_capabilities);
  }

  @override
  String toString() {
    return 'ModelConfig(id: $id, name: $name, provider: $provider, modelId: $modelId, apiKey: $apiKey, endpoint: $endpoint, deployment: $deployment, systemInstruction: $systemInstruction, temperature: $temperature, topP: $topP, topK: $topK, capabilities: $capabilities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModelConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.modelId, modelId) || other.modelId == modelId) &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.endpoint, endpoint) ||
                other.endpoint == endpoint) &&
            (identical(other.deployment, deployment) ||
                other.deployment == deployment) &&
            (identical(other.systemInstruction, systemInstruction) ||
                other.systemInstruction == systemInstruction) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.topP, topP) || other.topP == topP) &&
            (identical(other.topK, topK) || other.topK == topK) &&
            const DeepCollectionEquality()
                .equals(other._capabilities, _capabilities));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      provider,
      modelId,
      apiKey,
      endpoint,
      deployment,
      systemInstruction,
      temperature,
      topP,
      topK,
      const DeepCollectionEquality().hash(_capabilities));

  /// Create a copy of ModelConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModelConfigImplCopyWith<_$ModelConfigImpl> get copyWith =>
      __$$ModelConfigImplCopyWithImpl<_$ModelConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModelConfigImplToJson(
      this,
    );
  }
}

abstract class _ModelConfig implements ModelConfig {
  const factory _ModelConfig(
      {required final String id,
      required final String name,
      required final AIProvider provider,
      required final String modelId,
      final String? apiKey,
      final String? endpoint,
      final String? deployment,
      required final String systemInstruction,
      required final double temperature,
      required final double topP,
      required final int topK,
      final List<String> capabilities}) = _$ModelConfigImpl;

  factory _ModelConfig.fromJson(Map<String, dynamic> json) =
      _$ModelConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get name; // ユーザーフレンドリーな名前（例："My Creative Gemini"）
  @override
  AIProvider get provider;
  @override
  String get modelId; // モデル識別子（例："gemini-2.5-flash", "gpt-4", "llama3"）
// 接続詳細
  @override
  String? get apiKey;
  @override
  String? get endpoint; // Azure/Local用
  @override
  String? get deployment; // Azure固有
// パラメーター
  @override
  String get systemInstruction;
  @override
  double get temperature;
  @override
  double get topP;
  @override
  int get topK; // 機能
  @override
  List<String> get capabilities;

  /// Create a copy of ModelConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModelConfigImplCopyWith<_$ModelConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
