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

final class RoutineBook extends RoutineState {
  final int id;

  const RoutineBook(this.id);
}

// final class OrderMixSuccess extends RoutineState {
//   final int id;
//
//   const OrderMixSuccess(this.id);
// }

final class RoutineError extends RoutineState {
  final String message;

  const RoutineError(this.message);
}
