part of 'address_bloc.dart';

@immutable
sealed class AddressEvent {}

class RefreshAddressEvent extends AddressEvent {}

class GetListAddressEvent extends AddressEvent {
  final GetAddressAutoCompleteParams params;

  GetListAddressEvent(this.params);
}
