part of 'ai_chat_bloc.dart';

@immutable
sealed class AiChatState {}

final class AiChatInitial extends AiChatState {}

final class AiChatLoading extends AiChatState {}

final class AiChatLoaded extends AiChatState {
  final String message;

  AiChatLoaded(this.message);
}

final class AiChatError extends AiChatState {
  final String message;

  AiChatError(this.message);
}
