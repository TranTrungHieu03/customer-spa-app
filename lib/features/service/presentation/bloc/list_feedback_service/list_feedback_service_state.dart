part of 'list_feedback_service_bloc.dart';

@immutable
sealed class ListFeedbackServiceState {}

final class ListFeedbackServiceInitial extends ListFeedbackServiceState {}

final class ListFeedbackServiceLoading extends ListFeedbackServiceState {}

final class ListFeedbackServiceLoaded extends ListFeedbackServiceState {
  final List<ServiceFeedbackModel> feedbacks;
  final double average;

  ListFeedbackServiceLoaded({
    required this.feedbacks,
    required this.average,
  });
}

final class ListFeedbackServiceError extends ListFeedbackServiceState {
  final String message;

  ListFeedbackServiceError(this.message);
}
