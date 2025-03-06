part of 'staff_bloc.dart';

@immutable
sealed class StaffState {}

final class StaffInitial extends StaffState {}

final class StaffLoaded extends StaffState {
  final StaffModel staff;

  StaffLoaded({required this.staff});
}

final class StaffError extends StaffState {
  final String message;

  StaffError(
    this.message,
  );
}

final class StaffLoading extends StaffState {}
