import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/home/data/models/message_channel_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_list_message.dart';

part 'list_message_event.dart';
part 'list_message_state.dart';

class ListMessageBloc extends Bloc<ListMessageEvent, ListMessageState> {
  final GetListMessage _getListMessage;

  ListMessageBloc({
    required GetListMessage getListMessage,
  })  : _getListMessage = getListMessage,
        super(ListMessageInitial()) {
    on<ListMessageEvent>((event, emit) async {
      if (event is GetListMessageEvent) {
        emit(ListMessageLoading());
        final result = await _getListMessage(event.params);
        result.fold(
          (failure) => emit(ListMessageError(failure.message)),
          (messages) => emit(ListMessageLoaded(messages)),
        );
      }
    });
    on<ListMessageNewMessageEvent>((event, emit) {
      if (state is ListMessageLoaded) {
        final currentState = state as ListMessageLoaded;
        final updatedMessages = List<MessageChannelModel>.from(currentState.messages)..add(event.newMessage);
        emit(ListMessageLoaded(updatedMessages));
      }
    });
  }
}
