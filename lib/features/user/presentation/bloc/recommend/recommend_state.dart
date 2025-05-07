part of 'recommend_bloc.dart';

@immutable
sealed class RecommendState {}

final class RecommendInitial extends RecommendState {}

final class RecommendLoading extends RecommendState {}

final class RecommendLoaded extends RecommendState {
  final ListServiceProductModel data;

  RecommendLoaded(this.data);
}

final class RecommendError extends RecommendState {
  final String message;

  RecommendError(this.message);
}
