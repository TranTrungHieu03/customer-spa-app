part of 'list_staff_bloc.dart';

@immutable
sealed class ListStaffEvent {}

class GetListStaffEvent extends ListStaffEvent {
  final int id;

  GetListStaffEvent({required this.id});
}

class GetSingleStaffEvent extends ListStaffEvent {
  final int staffId;

  GetSingleStaffEvent({required this.staffId});
}
