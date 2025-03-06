part of 'payos_bloc.dart';

@immutable
sealed class PayosState {}



class PayosInitial extends PayosState {}

class PayosLoading extends PayosState {}

class PayosWebViewLoaded extends PayosState {}

class PayosSuccess extends PayosState {}

class PayosFailure extends PayosState {}
