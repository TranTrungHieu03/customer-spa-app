class ShipmentModel {
  final String address;
  final String name;
  final String phoneNumber;
  final String districtId;
  final String wardCode;

  ShipmentModel({required this.address, required this.name, required this.phoneNumber, required this.districtId, required this.wardCode});

  factory ShipmentModel.empty() => ShipmentModel(address: "", name: "", phoneNumber: "", wardCode: "", districtId: "");
}
