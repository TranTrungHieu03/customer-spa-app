class AddressModel {
  final String fullAddress;
  final String district;
  final String commune;
  final String province;

  AddressModel({required this.district, required this.fullAddress, required this.commune, required this.province});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
        district: json['compound']['district'],
        fullAddress: json['description'],
        commune: json['compound']['commune'],
        province: json['compound']['province']);
  }

  static AddressModel empty() => AddressModel(district: "", fullAddress: "", commune: "", province: "");

  bool get isEmpty => district.isEmpty && fullAddress.isEmpty && commune.isEmpty && province.isEmpty;
}
