part of 'list_notification_bloc.dart';

@immutable
sealed class ListNotificationEvent {}

final class GetAllNotificationEvent extends ListNotificationEvent {
  final GetAllNotificationParams params;

  GetAllNotificationEvent(this.params);
}

final class AddNewNotificationEvent extends ListNotificationEvent {
  final List<NotificationModel> notifications;

  AddNewNotificationEvent(this.notifications);
}

final class ResetNotificationEvent extends ListNotificationEvent {}
