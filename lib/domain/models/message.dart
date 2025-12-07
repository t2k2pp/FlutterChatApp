import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_chat_app/domain/enums/role.dart';
import 'package:flutter_chat_app/domain/models/reasoning_step.dart';
import 'package:flutter_chat_app/domain/models/token_usage.dart';
import 'package:flutter_chat_app/domain/models/message_image.dart';

part 'message.freezed.dart';
part 'message.g.dart';

/// チャットメッセージを表すモデル
@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required Role role,
    required String text,
    required int timestamp,
    @Default(false) bool isError,
    List<ReasoningStep>? reasoningLogs, // Deep Researchの可視性用
    @Default(true) bool includedInContext, // メインAIに表示されるか
    bool? watsonChecked, // Watsonが確認して介入しなかった場合 true
    TokenUsage? usage, // このメッセージ生成のトークン使用量
    List<MessageImage>? images, // 履歴/表示用の格納画像
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
