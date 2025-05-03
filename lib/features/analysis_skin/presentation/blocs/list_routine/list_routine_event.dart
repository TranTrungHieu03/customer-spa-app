part of 'list_routine_bloc.dart';

@immutable
sealed class ListRoutineEvent {}

final class GetListRoutineEvent extends ListRoutineEvent {}

final class GetHistoryRoutineEvent extends ListRoutineEvent {
  final GetRoutineHistoryParams params;

  GetHistoryRoutineEvent(this.params);
}

final class GetSuitableRoutineEvent extends ListRoutineEvent {
  final GetRoutineHistoryParams params;

  GetSuitableRoutineEvent(this.params);
}
