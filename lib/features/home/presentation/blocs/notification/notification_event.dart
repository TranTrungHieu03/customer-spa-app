part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

final class MarkAsReadEvent extends NotificationEvent {
  final MarkAsReadParams params;

  MarkAsReadEvent(this.params);
}

final class MarkAsReadAllEvent extends NotificationEvent {
  final MarkAsReadAllParams params;

  MarkAsReadAllEvent(this.params);
}
