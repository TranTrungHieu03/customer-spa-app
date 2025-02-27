part of 'routine_bloc.dart';

@immutable
sealed class RoutineEvent {}

final class GetRoutineDetailEvent extends RoutineEvent {
  final GetRoutineDetailParams params;

  GetRoutineDetailEvent(this.params);
}
