part of 'list_routine_step_bloc.dart';

@immutable
sealed class ListRoutineStepState {}

final class ListRoutineStepInitial extends ListRoutineStepState {}

final class ListRoutineStepLoaded extends ListRoutineStepState {
  final List<RoutineStepModel> routines;

  ListRoutineStepLoaded(this.routines);
}

final class ListRoutineStepError extends ListRoutineStepState {
  final String message;

  ListRoutineStepError(this.message);
}

final class ListRoutineStepLoading extends ListRoutineStepState {}
