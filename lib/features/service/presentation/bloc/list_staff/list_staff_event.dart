part of 'list_staff_bloc.dart';

@immutable
sealed class ListStaffEvent {}

class GetListStaffEvent extends ListStaffEvent {
  final GetListStaffParams params;

  GetListStaffEvent({required this.params});
}

class GetSingleStaffEvent extends ListStaffEvent {
  final int staffId;

  GetSingleStaffEvent({required this.staffId});
}

class GetStaffFreeInTimeEvent extends ListStaffEvent {
  final GetStaffFreeInTimeParams params;

  GetStaffFreeInTimeEvent({required this.params});
}
