part of 'list_feedback_service_bloc.dart';

@immutable
sealed class ListFeedbackServiceEvent {}

final class GetListFeedbackServiceEvent extends ListFeedbackServiceEvent {
  final GetListFeedbackServiceParams params;

  GetListFeedbackServiceEvent(this.params);
}
