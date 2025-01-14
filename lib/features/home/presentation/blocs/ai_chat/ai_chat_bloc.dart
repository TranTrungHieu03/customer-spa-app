import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_ai_chat.dart';

part 'ai_chat_event.dart';
part 'ai_chat_state.dart';

class AiChatBloc extends Bloc<AiChatEvent, AiChatState> {
  final GetAiChat _getAiChat;

  AiChatBloc({
    required GetAiChat getAiChat,
  })  : _getAiChat = getAiChat,
        super(AiChatInitial()) {
    on<GetAiChatEvent>(_onGetAiChat);
  }

  Future<void> _onGetAiChat(GetAiChatEvent event, Emitter<AiChatState> emit) async {
    emit(AiChatLoading());
    AppLogger.info(event.params.toJson());
    final result = await _getAiChat(event.params);
    result.fold(
      (failure) => emit(AiChatError(failure.message)),
      (message) => emit(AiChatLoaded(message)),
    );
  }
}
