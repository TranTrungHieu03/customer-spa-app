part of 'list_routine_logger_bloc.dart';

@immutable
sealed class ListRoutineLoggerEvent {}

final class GetListRoutineLoggerEvent extends ListRoutineLoggerEvent {
  final GetFeedbackStepParams params;

  GetListRoutineLoggerEvent(this.params);
}
