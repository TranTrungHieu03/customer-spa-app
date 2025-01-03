import 'package:equatable/equatable.dart';

class MessageChat extends Equatable {
  final String text;
  final bool isUser;

  const MessageChat({
    required this.text,
    required this.isUser,
  });

  @override
  List<Object> get props => [text, isUser];
}
