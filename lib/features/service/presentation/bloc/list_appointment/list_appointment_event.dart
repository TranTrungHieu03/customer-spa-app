part of 'list_appointment_bloc.dart';

@immutable
sealed class ListAppointmentEvent {}

final class GetListAppointmentEvent extends ListAppointmentEvent {
  final GetListAppointmentParams params;

  GetListAppointmentEvent(this.params);
}

final class GetListAppointmentByRoutineEvent extends ListAppointmentEvent {
  final GetListAppointmentByRoutineParams params;

  GetListAppointmentByRoutineEvent(this.params);
}
