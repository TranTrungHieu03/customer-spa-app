part of 'routine_bloc.dart';

@immutable
sealed class RoutineState {
  const RoutineState();
}

final class RoutineInitial extends RoutineState {}

final class RoutineLoading extends RoutineState {}

final class RoutineLoaded extends RoutineState {
  final RoutineModel routineModel;

  const RoutineLoaded(this.routineModel);
}

final class RoutineError extends RoutineState {
  final String message;

  const RoutineError(this.message);
}
