part of 'appointment_bloc.dart';

@immutable
sealed class AppointmentEvent {}



final class GetAppointmentEvent extends AppointmentEvent {
  final int id;

  GetAppointmentEvent(this.id);
}

final class CreateAppointmentEvent extends AppointmentEvent {
  final CreateAppointmentParams params;

  CreateAppointmentEvent(this.params);
}
final class ResetAppointmentEvent extends AppointmentEvent {}