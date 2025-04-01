part of 'address_bloc.dart';

@immutable
sealed class AddressState {}

final class AddressInitial extends AddressState {}

final class AddressLoading extends AddressState {}

final class AddressProvinceLoaded extends AddressState {
  final List<ProvinceModel> provinces;
  final List<DistrictModel> districts;
  final List<WardModel> wards;
  final bool isLoadingDistrict;
  final bool isLoadingCommune;

  AddressProvinceLoaded(
      {required this.provinces,
      required this.districts,
      required this.wards,
      required this.isLoadingCommune,
      required this.isLoadingDistrict});
}

final class AddressDistrictLoaded extends AddressState {
  final List<DistrictModel> districts;

  AddressDistrictLoaded(this.districts);
}

final class AddressCommuneLoaded extends AddressState {
  final List<WardModel> wards;

  AddressCommuneLoaded(this.wards);
}

final class AddressError extends AddressState {
  final String message;

  AddressError(this.message);
}
