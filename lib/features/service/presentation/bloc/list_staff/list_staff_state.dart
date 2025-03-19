part of 'list_staff_bloc.dart';

@immutable
sealed class ListStaffState {}

final class ListStaffInitial extends ListStaffState {}

final class ListStaffLoading extends ListStaffState {}

final class ListStaffLoaded extends ListStaffState {
  final List<StaffServiceModel> listStaff;
  final List<StaffModel> intersectionStaff;

  ListStaffLoaded({required this.listStaff,required this.intersectionStaff  });
}

final class ListStaffEmpty extends ListStaffState {}
final class ListStaffError extends ListStaffState {
  final String message;

  ListStaffError({required this.message});
}