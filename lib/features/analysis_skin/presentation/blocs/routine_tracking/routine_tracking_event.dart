part of 'routine_tracking_bloc.dart';

@immutable
sealed class RoutineTrackingEvent {}

final class GetRoutineTrackingEvent extends RoutineTrackingEvent {
  final GetRoutineTrackingParams params;

  GetRoutineTrackingEvent(this.params);
}
