import 'package:spa_mobile/features/home/domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.userId,
    required super.message,
    required super.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      userId: json['userId'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
