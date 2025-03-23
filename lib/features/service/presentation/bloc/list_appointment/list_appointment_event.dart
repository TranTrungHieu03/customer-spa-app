part of 'list_appointment_bloc.dart';

@immutable
sealed class ListAppointmentEvent {
  final int page;
  final String title;

  const ListAppointmentEvent({required this.page, required this.title});
}

final class GetListAppointmentEvent extends ListAppointmentEvent {
  const GetListAppointmentEvent({required super.page, required super.title});
}

