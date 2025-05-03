part of 'list_routine_logger_bloc.dart';

@immutable
sealed class ListRoutineLoggerState {}

final class ListRoutineLoggerInitial extends ListRoutineLoggerState {}

final class ListRoutineLoggerLoading extends ListRoutineLoggerState {}

final class ListRoutineLoggerLoaded extends ListRoutineLoggerState {
  final List<RoutineLoggerModel> feedbacks;

  ListRoutineLoggerLoaded(this.feedbacks);
}

final class ListRoutineLoggerError extends ListRoutineLoggerState {
  final String message;

  ListRoutineLoggerError(this.message);
}
