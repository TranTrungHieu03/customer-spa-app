part of 'list_appointment_bloc.dart';

@immutable
sealed class ListAppointmentState {
  const ListAppointmentState();
}

final class ListAppointmentInitial extends ListAppointmentState {}

final class ListAppointmentLoaded extends ListAppointmentState {
  final List<AppointmentModel> pending;
  final List<AppointmentModel> completed;
  final List<AppointmentModel> cancelled;

  final bool isLoadingMorePending;
  final bool isLoadingMoreCompleted;
  final bool isLoadingMoreCancelled;

  final PaginationModel paginationPending;
  final PaginationModel paginationCompleted;
  final PaginationModel paginationCancelled;

  const ListAppointmentLoaded({
    required this.pending,
    required this.completed,
    required this.isLoadingMorePending,
    required this.isLoadingMoreCompleted,
    required this.paginationPending,
    required this.paginationCompleted,
    required this.cancelled,
    required this.isLoadingMoreCancelled,
    required this.paginationCancelled,
  });

  ListAppointmentLoaded copyWith({
    List<AppointmentModel>? pending,
    List<AppointmentModel>? completed,
    List<AppointmentModel>? cancelled,
    bool? isLoadingMorePending,
    bool? isLoadingMoreCompleted,
    bool? isLoadingMoreCancelled,
    PaginationModel? paginationPending,
    PaginationModel? paginationCompleted,
    PaginationModel? paginationCancelled,
  }) {
    return ListAppointmentLoaded(
      pending: pending ?? this.pending,
      completed: completed ?? this.completed,
      cancelled: cancelled ?? this.cancelled,
      isLoadingMorePending: isLoadingMorePending ?? this.isLoadingMorePending,
      isLoadingMoreCompleted: isLoadingMoreCompleted ?? this.isLoadingMoreCompleted,
      isLoadingMoreCancelled: isLoadingMoreCancelled ?? this.isLoadingMoreCancelled,
      paginationPending: paginationPending ?? this.paginationPending,
      paginationCompleted: paginationCompleted ?? this.paginationCompleted,
      paginationCancelled: paginationCancelled ?? this.paginationCancelled,
    );
  }
}

final class ListAppointmentLoading extends ListAppointmentState {
  final List<AppointmentModel> pending;
  final List<AppointmentModel> completed;
  final List<AppointmentModel> cancelled;

  final bool isLoadingMorePending;
  final bool isLoadingMoreCompleted;
  final bool isLoadingMoreCancelled;

  final PaginationModel paginationPending;
  final PaginationModel paginationCompleted;
  final PaginationModel paginationCancelled;

  const ListAppointmentLoading({
    required this.pending,
    required this.completed,
    required this.isLoadingMorePending,
    required this.isLoadingMoreCompleted,
    required this.paginationPending,
    required this.paginationCompleted,
    required this.cancelled,
    required this.isLoadingMoreCancelled,
    required this.paginationCancelled,
  });

  ListAppointmentLoading copyWith({
    List<AppointmentModel>? pending,
    List<AppointmentModel>? completed,
    List<AppointmentModel>? cancelled,
    bool? isLoadingMorePending,
    bool? isLoadingMoreCompleted,
    bool? isLoadingMoreCancelled,
    PaginationModel? paginationPending,
    PaginationModel? paginationCompleted,
    PaginationModel? paginationCancelled,
  }) {
    return ListAppointmentLoading(
      pending: pending ?? this.pending,
      completed: completed ?? this.completed,
      cancelled: cancelled ?? this.cancelled,
      isLoadingMorePending: isLoadingMorePending ?? this.isLoadingMorePending,
      isLoadingMoreCompleted: isLoadingMoreCompleted ?? this.isLoadingMoreCompleted,
      isLoadingMoreCancelled: isLoadingMoreCancelled ?? this.isLoadingMoreCancelled,
      paginationPending: paginationPending ?? this.paginationPending,
      paginationCompleted: paginationCompleted ?? this.paginationCompleted,
      paginationCancelled: paginationCancelled ?? this.paginationCancelled,
    );
  }
}

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
