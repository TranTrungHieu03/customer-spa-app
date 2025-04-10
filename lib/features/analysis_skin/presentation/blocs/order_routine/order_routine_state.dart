part of 'order_routine_bloc.dart';

@immutable
sealed class OrderRoutineState {}

final class OrderRoutineInitial extends OrderRoutineState {}

final class OrderRoutineLoading extends OrderRoutineState {}

final class OrderRoutineLoaded extends OrderRoutineState {
  final OrderRoutineModel order;

  OrderRoutineLoaded(this.order);
}

final class OrderRoutineError extends OrderRoutineState {
  final String message;

  OrderRoutineError(this.message);
}
