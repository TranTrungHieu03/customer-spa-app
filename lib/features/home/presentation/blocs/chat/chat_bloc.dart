import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/data/models/message_channel_model.dart';
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

  StreamSubscription<MessageChannelModel>? _messagesSubscription;
  final List<MessageChannelModel> _messages = [];

  ChatBloc({
    required this.getMessages,
    required this.sendMessage,
    required this.connect,
    required this.disconnect,
  }) : super(ChatInitial()) {
    on<ChatConnectEvent>(_onConnect);
    on<ChatDisconnectEvent>(_onDisconnect);
    on<ChatSendMessageEvent>(_onSendMessage);

    on<ChatMessageReceivedEvent>(_onMessageReceived);
  }

  Future<void> _onConnect(ChatConnectEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    try {
      await connect(NoParams());
      _setupMessageStream(emit);

      emit(ChatLoaded(List.from(_messages)));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _setupMessageStream(Emitter<ChatState> emit) {
    _messagesSubscription?.cancel();

    final stream = getMessages(NoParams());

    _messagesSubscription = stream.listen(
      (message) => add(ChatMessageReceivedEvent(message)),
      cancelOnError: false,
    );
  }

  Future<void> _onDisconnect(ChatDisconnectEvent event, Emitter<ChatState> emit) async {
    await _messagesSubscription?.cancel();
    final result = await disconnect(NoParams());

    result.fold(
      (failure) {
        emit(ChatError(failure.message));
      },
      (_) {
        // Optionally handle successful disconnect
      },
    );
  }

  Future<void> _onSendMessage(ChatSendMessageEvent event, Emitter<ChatState> emit) async {
    final result = await sendMessage(event.params);

    result.fold(
      (failure) {
        emit(ChatError(failure.message));
      },
      (_) {},
    );
  }

  void _onMessageReceived(ChatMessageReceivedEvent event, Emitter<ChatState> emit) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;

      emit(ChatLoaded([...currentState.messages, event.message]));
    } else if (state is ChatInitial || state is ChatError) {
      emit(ChatLoaded([event.message]));
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
