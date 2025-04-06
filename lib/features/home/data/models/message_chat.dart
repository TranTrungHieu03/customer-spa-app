import 'package:spa_mobile/features/home/domain/entities/message_chat.dart';

class MessageChatModel extends MessageChat {
  const MessageChatModel({required super.text, required super.isUser});

  factory MessageChatModel.fromJson(Map<String, dynamic> json) {
    return MessageChatModel(
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
    );
  }
}
