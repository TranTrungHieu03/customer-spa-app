part of 'list_routine_step_bloc.dart';

@immutable
sealed class ListRoutineStepEvent {}

final class GetRoutineStepEvent extends ListRoutineStepEvent {
  final GetRoutineStepParams params;

  GetRoutineStepEvent(this.params);
}
