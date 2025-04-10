part of 'feedback_product_bloc.dart';

@immutable
sealed class FeedbackProductState {}

final class FeedbackProductInitial extends FeedbackProductState {}

final class FeedbackProductLoading extends FeedbackProductState {}

final class FeedbackProductError extends FeedbackProductState {
  final String message;

  FeedbackProductError(this.message);
}

final class FeedbackProductLoaded extends FeedbackProductState {
  final ProductFeedbackModel feedback;

  FeedbackProductLoaded(this.feedback);
}
