part of 'routine_bloc.dart';

@immutable
sealed class RoutineEvent {}

final class GetRoutineDetailEvent extends RoutineEvent {
  final GetRoutineDetailParams params;

  GetRoutineDetailEvent(this.params);
}

final class BookRoutineDetailEvent extends RoutineEvent {
  final BookRoutineParams params;

  BookRoutineDetailEvent(this.params);
}

final class RefreshRoutineEvent extends RoutineEvent {}

final class GetCurrentRoutineEvent extends RoutineEvent {
  final GetCurrentRoutineParams params;

  GetCurrentRoutineEvent(this.params);
}

