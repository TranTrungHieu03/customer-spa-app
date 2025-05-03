part of 'routine_logger_bloc.dart';

@immutable
sealed class RoutineLoggerState {}

final class RoutineLoggerInitial extends RoutineLoggerState {}

final class RoutineLoggerLoading extends RoutineLoggerState {}

final class RoutineLoggerCreated extends RoutineLoggerState {}

final class RoutineLoggerLoaded extends RoutineLoggerState {}

final class RoutineLoggerError extends RoutineLoggerState {
  final String message;

  RoutineLoggerError(this.message);
}
