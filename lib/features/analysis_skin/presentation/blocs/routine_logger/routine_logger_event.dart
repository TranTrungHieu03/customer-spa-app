part of 'routine_logger_bloc.dart';

@immutable
sealed class RoutineLoggerEvent {}

final class CreateRoutineLoggerEvent extends RoutineLoggerEvent {
  final FeedbackStepParams params;

  CreateRoutineLoggerEvent(this.params);
}
