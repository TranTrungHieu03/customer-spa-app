part of 'ai_chat_bloc.dart';

@immutable
sealed class AiChatEvent {}

final class GetAiChatEvent extends AiChatEvent {
  final GetAiChatParams params;

  GetAiChatEvent(this.params);
}
