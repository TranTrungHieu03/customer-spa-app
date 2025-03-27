part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatConnectEvent extends ChatEvent {}

class ChatDisconnectEvent extends ChatEvent {}

class ChatSendMessageEvent extends ChatEvent {
  final String message;

  const ChatSendMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}

class ChatMessagesReceivedEvent extends ChatEvent {}
