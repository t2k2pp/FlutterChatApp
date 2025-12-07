import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_image.freezed.dart';
part 'message_image.g.dart';

/// メッセージに添付された画像を表すモデル
@freezed
class MessageImage with _$MessageImage {
  const factory MessageImage({
    required String base64,
    required String mimeType,
  }) = _MessageImage;

  factory MessageImage.fromJson(Map<String, dynamic> json) =>
      _$MessageImageFromJson(json);
}
