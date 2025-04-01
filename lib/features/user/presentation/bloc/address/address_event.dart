part of 'address_bloc.dart';

@immutable
sealed class AddressEvent {}

class RefreshAddressEvent extends AddressEvent {}

class GetListAddressEvent extends AddressEvent {
  final GetAddressAutoCompleteParams params;

  GetListAddressEvent(this.params);
}

class GetListProvinceEvent extends AddressEvent {}

class GetListDistrictEvent extends AddressEvent {
  final GetDistrictParams params;

  GetListDistrictEvent(this.params);
}

class GetListCommuneEvent extends AddressEvent {
  final GetWardParams params;

  GetListCommuneEvent(this.params);
}
