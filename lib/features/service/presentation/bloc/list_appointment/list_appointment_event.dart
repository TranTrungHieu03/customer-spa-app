part of 'list_appointment_bloc.dart';

@immutable
sealed class ListAppointmentEvent {
  final int page;
  final String title;

  const ListAppointmentEvent({required this.page, required this.title});
}



final class GetListAppointmentDoneEvent extends ListAppointmentEvent {
  GetListAppointmentDoneEvent({required super.page, required super.title});
}

final class GetListAppointmentUpcomingEvent extends ListAppointmentEvent {
  GetListAppointmentUpcomingEvent({required super.page, required super.title});
}

final class GetListAppointmentCancelEvent extends ListAppointmentEvent {
  GetListAppointmentCancelEvent({required super.page, required super.title});
}