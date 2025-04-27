part of 'mix_bloc.dart';

@immutable
sealed class MixEvent {}

final class OrderMixEvent extends MixEvent {
  final OrderMixParams params;

  OrderMixEvent(this.params);
}
