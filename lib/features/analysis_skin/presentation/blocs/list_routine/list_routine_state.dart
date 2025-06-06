part of 'list_routine_bloc.dart';

@immutable
sealed class ListRoutineState {}

final class ListRoutineInitial extends ListRoutineState {}

final class ListRoutineLoaded extends ListRoutineState {
  final List<RoutineModel> routines;
  final List<RoutineModel> suitable;

  ListRoutineLoaded({
    required this.routines,
    required this.suitable,
  });

  ListRoutineLoaded copyWith({
    List<RoutineModel>? routines,
    List<RoutineModel>? suitable,
  }) {
    return ListRoutineLoaded(
      routines: routines ?? this.routines,
      suitable: suitable ?? this.suitable,
    );
  }
}

final class ListRoutineHistoryLoaded extends ListRoutineState {
  final List<RoutineModel> active;
  final List<RoutineModel> cancelled;
  final List<RoutineModel> completed;

  ListRoutineHistoryLoaded({required this.active, required this.cancelled, required this.completed});
}

final class ListRoutineHistoryLoading extends ListRoutineState {
  final List<RoutineModel> active;
  final List<RoutineModel> cancelled;
  final List<RoutineModel> completed;

  ListRoutineHistoryLoading({required this.active, required this.cancelled, required this.completed});
}

final class ListRoutineError extends ListRoutineState {
  final String message;

  ListRoutineError(this.message);
}

final class ListRoutineLoading extends ListRoutineState {}
