import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_chat_app/domain/models/message.dart';

part 'chat_session.freezed.dart';
part 'chat_session.g.dart';

/// チャットセッションを表すモデル
@freezed
class ChatSession with _$ChatSession {
  const factory ChatSession({
    required String id,
    String? projectId, // プロジェクトへのオプションリンク
    required String title,
    required List<Message> messages,
    required int updatedAt,
  }) = _ChatSession;

  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionFromJson(json);
}
