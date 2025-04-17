part of 'staff_slot_working_bloc.dart';

@immutable
sealed class StaffSlotWorkingEvent {}

class GetStaffSlotWorkingEvent extends StaffSlotWorkingEvent {
  final GetListSlotWorkingParams params;

  GetStaffSlotWorkingEvent(this.params);
}
