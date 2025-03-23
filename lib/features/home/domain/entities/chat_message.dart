import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String userId;
  final String message;
  final DateTime timestamp;

  const ChatMessage({
    required this.userId,
    required this.message,
    required this.timestamp,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [userId, message, timestamp];
}
