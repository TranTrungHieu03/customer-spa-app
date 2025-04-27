part of 'mix_bloc.dart';

@immutable
sealed class MixState {}

final class MixInitial extends MixState {}

final class OrderMixSuccess extends MixState {
  final int id;

  OrderMixSuccess(this.id);
}

final class OrderMixLoading extends MixState {}

final class OrderMixError extends MixState {
  final String message;

  OrderMixError(this.message);
}
