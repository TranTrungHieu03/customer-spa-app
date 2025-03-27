import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/data/models/chat_message.dart';
import 'package:spa_mobile/features/home/domain/usecases/connect_hub.dart';
import 'package:spa_mobile/features/home/domain/usecases/disconnect_hub.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_message.dart';
import 'package:spa_mobile/features/home/domain/usecases/send_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;
  final ConnectHub connect;
  final DisconnectHub disconnect;

  ChatBloc({
    required this.getMessages,
    required this.sendMessage,
    required this.connect,
    required this.disconnect,
  }) : super(ChatInitial()) {
    on<ChatConnectEvent>((event, emit) async {
      emit(ChatLoading());
      await connect(NoParams());
      emit(ChatLoaded([]));
      final result = await getMessages(NoParams());
      result.fold((failure) => emit(ChatError("Error getting messages.")), (stream) {
        stream.listen((message) {
          if (state is ChatLoaded) {
            final currentState = state as ChatLoaded;
            final updatedMessages = List<ChatMessageModel>.from(currentState.messages)..add(message);
            add(ChatMessagesReceivedEvent());
            emit(ChatLoaded(updatedMessages));
          }
        });
      });
    });

    on<ChatDisconnectEvent>((event, emit) async {
      await disconnect(NoParams());
      emit(ChatInitial());
    });

    on<ChatSendMessageEvent>((event, emit) async {
      await sendMessage(SendMessageParams((event.message)));
    });

    on<ChatMessagesReceivedEvent>((event, emit) async {});
  }
}
