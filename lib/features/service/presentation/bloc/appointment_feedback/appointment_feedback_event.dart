part of 'appointment_feedback_bloc.dart';

@immutable
sealed class AppointmentFeedbackEvent {}

final class GetAppointmentFeedbackEvent extends AppointmentFeedbackEvent {
  final GetFeedbackParams params;

  GetAppointmentFeedbackEvent(this.params);
}
