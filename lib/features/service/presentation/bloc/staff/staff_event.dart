part of 'staff_bloc.dart';

@immutable
sealed class StaffEvent {}

final class GetStaffInfoEvent extends StaffEvent {
  final GetSingleStaffParams params;

  GetStaffInfoEvent(this.params);
}
