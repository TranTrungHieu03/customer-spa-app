part of 'list_routine_bloc.dart';

@immutable
sealed class ListRoutineState {}

final class ListRoutineInitial extends ListRoutineState {}

final class ListRoutineLoaded extends ListRoutineState {
  final List<RoutineModel> routines;

  ListRoutineLoaded(this.routines);
}

final class ListRoutineError extends ListRoutineState {
  final String message;

  ListRoutineError(this.message);
}

final class ListRoutineLoading extends ListRoutineState {}
