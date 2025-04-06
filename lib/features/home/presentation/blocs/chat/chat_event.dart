part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatConnectEvent extends ChatEvent {
  const ChatConnectEvent();
}

class ChatDisconnectEvent extends ChatEvent {}
class StartListeningEvent extends ChatEvent {}
class StopListeningEvent extends ChatEvent {}

class ChatSendMessageEvent extends ChatEvent {
  final SendMessageParams params;

  const ChatSendMessageEvent(this.params);

  @override
  List<Object> get props => [params];
}

class ChatMessageReceivedEvent extends ChatEvent {
  final MessageChannelModel message;

  const ChatMessageReceivedEvent(this.message);
}
