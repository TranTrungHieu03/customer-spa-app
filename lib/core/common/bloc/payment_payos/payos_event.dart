part of 'payos_bloc.dart';

@immutable
sealed class PayosEvent {}

class PayosSuccessful extends PayosEvent {}

class PayosInitiated extends PayosEvent {}

class PayosFailed extends PayosEvent {}

class PayosCancelled extends PayosEvent {}

class RetryPayos extends PayosEvent {}
