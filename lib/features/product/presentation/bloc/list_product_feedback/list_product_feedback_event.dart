part of 'list_product_feedback_bloc.dart';

@immutable
sealed class ListProductFeedbackEvent {}

final class GetListFeedbackProductEvent extends ListProductFeedbackEvent {
  final ListProductFeedbackParams params;

  GetListFeedbackProductEvent(this.params);
}
