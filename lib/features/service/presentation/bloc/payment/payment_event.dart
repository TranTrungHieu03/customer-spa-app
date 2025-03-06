part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent {}

final class PayFullEvent extends PaymentEvent {
  final PayFullParams params;

    PayFullEvent(this.params);
}
