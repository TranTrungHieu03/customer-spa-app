part of 'list_time_bloc.dart';

@immutable
sealed class ListTimeState {}

final class ListTimeInitial extends ListTimeState {}

final class ListTimeLoaded extends ListTimeState {
  final List<TimeModel> slots;

  ListTimeLoaded(this.slots);
}

final class ListTimeLoading extends ListTimeState {}
final class ListTimeEmpty extends ListTimeState {}

final class ListTimeError extends ListTimeState {
  final String message;

  ListTimeError(this.message);
}
