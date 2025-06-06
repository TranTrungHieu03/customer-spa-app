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

final class AppointmentDetailLoaded extends AppointmentState {
  final AppointmentModel appointment;

  const AppointmentDetailLoaded(this.appointment);
}

final class AppointmentCreateSuccess extends AppointmentState {
  final int id;

  const AppointmentCreateSuccess(this.id);
}

final class AppointmentUpdateRoutineSuccess extends AppointmentState {
  final int routineId;
  final int orderId;
  final int userId;

  const AppointmentUpdateRoutineSuccess({required this.routineId, required this.userId, required this.orderId});
}

final class AppointmentError extends AppointmentState {
  final String message;

  const AppointmentError(this.message);
}

final class AppointmentCreateData extends AppointmentState {
  final CreateAppointmentParams params;

  const AppointmentCreateData(this.params);
}

final class CancelAppointmentSuccess extends AppointmentState {
  final String error;
  final int orderId;

  CancelAppointmentSuccess({required this.orderId, required this.error});
}

final class CancelAppointmentDetailSuccess extends AppointmentState {
  final String message;

  const CancelAppointmentDetailSuccess(this.message);
}
