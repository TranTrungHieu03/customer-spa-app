part of 'order_routine_bloc.dart';

@immutable
sealed class OrderRoutineEvent {}

final class GetOrderRoutineDetailEvent extends OrderRoutineEvent {
  final GetOrderRoutineParams params;

  GetOrderRoutineDetailEvent(this.params);
}
