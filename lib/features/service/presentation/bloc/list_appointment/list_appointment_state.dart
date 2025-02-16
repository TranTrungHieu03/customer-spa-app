part of 'list_appointment_bloc.dart';

@immutable
sealed class ListAppointmentState {
  const ListAppointmentState();
}

final class ListAppointmentInitial extends ListAppointmentState {}

final class ListAppointmentLoading extends ListAppointmentState {}

final class ListAppointmentDoneLoaded extends ListAppointmentState {
  final List<AppointmentModel> appointments;

  final bool isLoadingMore;

  final PaginationModel pagination;

  const ListAppointmentDoneLoaded({
    required this.appointments,
    required this.pagination,
    this.isLoadingMore = false,
  });
}

final class ListAppointmentUpcomingLoaded extends ListAppointmentState {
  final List<AppointmentModel> appointments;

  final bool isLoadingMore;

  final PaginationModel pagination;

  const ListAppointmentUpcomingLoaded({
    required this.appointments,
    required this.pagination,
    this.isLoadingMore = false,
  });
}

final class ListAppointmentCancelLoaded extends ListAppointmentState {
  final List<AppointmentModel> appointments;

  final bool isLoadingMore;

  final PaginationModel pagination;

  const ListAppointmentCancelLoaded({
    required this.appointments,
    required this.pagination,
    this.isLoadingMore = false,
  });
}

final class ListAppointmentError extends ListAppointmentState {
  final String message;

  ListAppointmentError(this.message);
}
