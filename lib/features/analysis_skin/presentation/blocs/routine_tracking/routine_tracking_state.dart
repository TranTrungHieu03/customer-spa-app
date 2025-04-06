part of 'routine_tracking_bloc.dart';

@immutable
sealed class RoutineTrackingState {}

final class RoutineTrackingInitial extends RoutineTrackingState {}

final class RoutineTrackingLoading extends RoutineTrackingState {}

final class RoutineTracking extends RoutineTrackingState {
  final RoutineTrackingModel routine;

  RoutineTracking(this.routine);
}

final class RoutineTrackingError extends RoutineTrackingState {
  final String message;

  RoutineTrackingError(this.message);
}
