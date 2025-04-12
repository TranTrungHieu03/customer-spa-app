part of 'list_product_feedback_bloc.dart';

@immutable
sealed class ListProductFeedbackState {}

final class ListProductFeedbackInitial extends ListProductFeedbackState {}

final class ListProductFeedbackLoading extends ListProductFeedbackState {}

final class ListProductFeedbackLoaded extends ListProductFeedbackState {
  final List<ProductFeedbackModel> feedbacks;
  final double average;

  ListProductFeedbackLoaded({required this.feedbacks, required this.average});
}

final class ListProductFeedbackError extends ListProductFeedbackState {
  final String message;

  ListProductFeedbackError(this.message);
}
