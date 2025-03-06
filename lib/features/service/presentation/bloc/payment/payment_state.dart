part of 'payment_bloc.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

final class PaymentSuccess extends PaymentState {
  final String link;

  PaymentSuccess(this.link);
}

final class PaymentError extends PaymentState {
  final String message;

  PaymentError(this.message);
}

final class PaymentLoading extends PaymentState {}
