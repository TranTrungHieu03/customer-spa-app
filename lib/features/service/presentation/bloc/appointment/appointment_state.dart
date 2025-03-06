part of 'appointment_bloc.dart';

@immutable
sealed class AppointmentState {
  const AppointmentState();
}

final class AppointmentInitial extends AppointmentState {}

final class AppointmentLoading extends AppointmentState {}

final class AppointmentLoaded extends AppointmentState {
  final OrderAppointmentModel appointment;

  const AppointmentLoaded(this.appointment);
}

final class AppointmentCreateSuccess extends AppointmentState {
  final int id;

  const AppointmentCreateSuccess(this.id);
}

final class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError(this.message);
}

final class AppointmentCreateData extends AppointmentState {
  final CreateAppointmentParams params;

  const AppointmentCreateData(this.params);
}
