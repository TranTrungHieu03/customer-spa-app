part of 'list_order_routine_bloc.dart';

@immutable
sealed class ListOrderRoutineEvent {}

final class GetHistoryOrderRoutineEvent extends ListOrderRoutineEvent {
  final GetHistoryOrderRoutineParams params;

  GetHistoryOrderRoutineEvent(this.params);
}
