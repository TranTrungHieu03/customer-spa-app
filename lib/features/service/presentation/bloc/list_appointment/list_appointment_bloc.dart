import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'list_appointment_event.dart';
part 'list_appointment_state.dart';

class ListAppointmentBloc extends Bloc<ListAppointmentEvent, ListAppointmentState> {
  ListAppointmentBloc() : super(ListAppointmentInitial()) {
    on<ListAppointmentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
