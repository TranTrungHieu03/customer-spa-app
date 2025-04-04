import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'list_message_event.dart';
part 'list_message_state.dart';

class ListMessageBloc extends Bloc<ListMessageEvent, ListMessageState> {
  ListMessageBloc() : super(ListMessageInitial()) {
    on<ListMessageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
