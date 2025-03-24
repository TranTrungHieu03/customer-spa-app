part of 'address_bloc.dart';

@immutable
sealed class AddressState {}

final class AddressInitial extends AddressState {}

final class AddressLoading extends AddressState {}

final class AddressLoaded extends AddressState {
  final List<AddressModel> address;

  AddressLoaded(this.address);
}

final class AddressError extends AddressState {
  final String message;

  AddressError(this.message);
}
