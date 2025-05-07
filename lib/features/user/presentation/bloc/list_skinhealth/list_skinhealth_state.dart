part of 'list_skinhealth_bloc.dart';

@immutable
sealed class ListSkinhealthState {}

final class ListSkinhealthInitial extends ListSkinhealthState {}

final class ListSkinhealthLoading extends ListSkinhealthState {}

final class ListSkinhealthLoaded extends ListSkinhealthState {
  final List<SkinHealthStatisticModel> data;

  ListSkinhealthLoaded(this.data);
}

final class ListSkinhealthError extends ListSkinhealthState {
  final String message;

  ListSkinhealthError(this.message);
}
