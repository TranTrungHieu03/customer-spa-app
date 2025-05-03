part of 'home_state_bloc.dart';

@immutable
sealed class HomeStateEvent {}

final class GetNotificationEvent extends HomeStateEvent {
  final GetAllNotificationParams params;

  GetNotificationEvent(this.params);
}

final class ResetDataEvent extends HomeStateEvent {}
