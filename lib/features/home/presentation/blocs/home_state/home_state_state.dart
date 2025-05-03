part of 'home_state_bloc.dart';

@immutable
sealed class HomeStateState {}

final class HomeStateInitial extends HomeStateState {}

final class HomeStateLoading extends HomeStateState {}

final class HomeStateLoaded extends HomeStateState {
  final int newNoti;

  HomeStateLoaded({required this.newNoti});
}

final class HomeStateError extends HomeStateState {
  final String message;

  HomeStateError(this.message);
}
