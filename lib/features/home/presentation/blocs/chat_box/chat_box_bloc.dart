import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_box_event.dart';
part 'chat_box_state.dart';

class ChatBoxBloc extends Bloc<ChatBoxEvent, ChatBoxState> {
  ChatBoxBloc() : super(ChatBoxInitial()) {
    on<ChatBoxEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
