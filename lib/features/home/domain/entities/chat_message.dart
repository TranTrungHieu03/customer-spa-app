import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String userId;
  final String? content;
  final DateTime timestamp;
  final String channelId;
  final String messageType;
  final String? fileUrl;

  const ChatMessage({
    required this.userId,
    this.content,
    required this.timestamp,
    required this.channelId,
    this.messageType = 'text',
    this.fileUrl,
  });

  @override
  List<Object?> get props => [userId, content, timestamp, channelId, messageType, fileUrl];
}
