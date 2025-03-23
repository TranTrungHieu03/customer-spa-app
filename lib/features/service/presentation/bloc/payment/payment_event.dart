part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent {}

final class PayFullEvent extends PaymentEvent {
  final PayFullParams params;

  PayFullEvent(this.params);
}

final class PayDepositEvent extends PaymentEvent {
  final PayDepositParams params;

  PayDepositEvent(this.params);
}
