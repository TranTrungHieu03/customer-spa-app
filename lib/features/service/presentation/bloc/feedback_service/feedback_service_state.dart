part of 'feedback_service_bloc.dart';

@immutable
sealed class FeedbackServiceState {}

final class FeedbackServiceInitial extends FeedbackServiceState {}

final class FeedbackServiceLoading extends FeedbackServiceState {}

final class FeedbackServiceLoaded extends FeedbackServiceState {
  final ServiceFeedbackModel feedback;

  FeedbackServiceLoaded(this.feedback);
}

final class FeedbackServiceError extends FeedbackServiceState {
  final String message;

  FeedbackServiceError(this.message);
}
