part of 'list_time_bloc.dart';

@immutable
sealed class ListTimeEvent {}

final class GetListTimeByDateEvent extends ListTimeEvent {
  final GetTimeSlotByDateParams params;

  GetListTimeByDateEvent(this.params);
}
