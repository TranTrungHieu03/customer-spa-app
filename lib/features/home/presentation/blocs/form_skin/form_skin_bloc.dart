import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'form_skin_event.dart';
part 'form_skin_state.dart';

class FormSkinBloc extends Bloc<FormSkinEvent, FormSkinState> {
  FormSkinBloc() : super(FormSkinInitial()) {
    on<FormSkinEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
