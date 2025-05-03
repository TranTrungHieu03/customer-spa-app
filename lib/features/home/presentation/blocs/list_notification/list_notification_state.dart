part of 'list_notification_bloc.dart';

@immutable
sealed class ListNotificationState {}

final class ListNotificationInitial extends ListNotificationState {}

final class ListNotificationLoading extends ListNotificationState {}

final class ListNotificationLoaded extends ListNotificationState {
  final List<NotificationModel> notifications;
  final PaginationModel pagination;
  final bool isLoadingMore;

  ListNotificationLoaded({
    required this.notifications,
    required this.pagination,
    this.isLoadingMore = false,
  });

  ListNotificationLoaded copyWith({
    List<NotificationModel>? notifications,
    PaginationModel? pagination,
    bool? isLoadingMore,
  }) {
    return ListNotificationLoaded(
      notifications: notifications ?? this.notifications,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}


final class ListNotificationError extends ListNotificationState {
  final String message;

  ListNotificationError(this.message);
}
