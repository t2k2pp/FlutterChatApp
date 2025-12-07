// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_usage_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ModelUsageStatsImpl _$$ModelUsageStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$ModelUsageStatsImpl(
      modelId: json['modelId'] as String,
      totalPromptTokens: (json['totalPromptTokens'] as num?)?.toInt() ?? 0,
      totalCompletionTokens:
          (json['totalCompletionTokens'] as num?)?.toInt() ?? 0,
      totalTokens: (json['totalTokens'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ModelUsageStatsImplToJson(
        _$ModelUsageStatsImpl instance) =>
    <String, dynamic>{
      'modelId': instance.modelId,
      'totalPromptTokens': instance.totalPromptTokens,
      'totalCompletionTokens': instance.totalCompletionTokens,
      'totalTokens': instance.totalTokens,
    };
