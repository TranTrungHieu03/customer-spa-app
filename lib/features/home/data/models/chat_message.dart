import 'package:spa_mobile/features/home/domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel(
      {required super.userId,
      required super.timestamp,
      required super.channelId,
      super.messageType = 'text',
      super.content,
      super.fileUrl});

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      userId: json['userId'] as String,
      content: json['content'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      channelId: json['channelId'] as String,
      messageType: json['messageType'] as String,
      fileUrl: json['fileUrl'] as String?,
    );
  }
}
