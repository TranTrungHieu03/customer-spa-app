part of 'feedback_service_bloc.dart';

@immutable
sealed class FeedbackServiceEvent {}

final class SendFeedbackServiceEvent extends FeedbackServiceEvent {
  final FeedbackServiceParams params;

  SendFeedbackServiceEvent(this.params);
}
