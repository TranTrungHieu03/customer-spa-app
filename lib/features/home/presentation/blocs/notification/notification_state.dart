part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationLoading extends NotificationState {}

final class NotificationCreated extends NotificationState {
  final String message;

  NotificationCreated(this.message);
}

final class NotificationUpdatedAll extends NotificationState {
  final String message;

  NotificationUpdatedAll(this.message);
}

final class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
