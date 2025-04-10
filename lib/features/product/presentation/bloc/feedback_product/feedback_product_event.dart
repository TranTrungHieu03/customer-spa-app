part of 'feedback_product_bloc.dart';

@immutable
sealed class FeedbackProductEvent {}

class SendFeedbackProductEvent extends FeedbackProductEvent {
  final FeedbackProductParams params;

  SendFeedbackProductEvent(this.params);
}
