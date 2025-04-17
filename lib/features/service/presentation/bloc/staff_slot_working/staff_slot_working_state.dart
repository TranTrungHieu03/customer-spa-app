part of 'staff_slot_working_bloc.dart';

@immutable
sealed class StaffSlotWorkingState {}

final class StaffSlotWorkingInitial extends StaffSlotWorkingState {}

final class StaffSlotWorkingLoading extends StaffSlotWorkingState {}

final class StaffSlotWorkingLoaded extends StaffSlotWorkingState {
  final List<ShiftModel> staffSlotWorking;

  StaffSlotWorkingLoaded(this.staffSlotWorking);
}

final class StaffSlotWorkingError extends StaffSlotWorkingState {
  final String message;

  StaffSlotWorkingError(this.message);
}
