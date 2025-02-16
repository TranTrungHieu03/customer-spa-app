part of 'appointment_bloc.dart';

@immutable
sealed class AppointmentState {
  const AppointmentState();
}

final class AppointmentInitial extends AppointmentState {}

final class AppointmentLoading extends AppointmentState {}

final class AppointmentLoaded extends AppointmentState {
  final AppointmentModel appointment;

  const AppointmentLoaded(this.appointment);
}

final class AppointmentCreateSuccess extends AppointmentState {
  final List<AppointmentModel> appointment;

  const AppointmentCreateSuccess(this.appointment);
}

final class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError(this.message);
}
