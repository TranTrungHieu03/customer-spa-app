part of 'recommend_bloc.dart';

@immutable
sealed class RecommendEvent {}

final class GetListRecommendEvent extends RecommendEvent {
  final GetRecommendParams params;

  GetListRecommendEvent(this.params);
}
