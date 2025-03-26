import 'package:spa_mobile/features/product/domain/entities/ward.dart';

class WardModel extends Ward {
  const WardModel({required super.wardCode, required super.districtId, required super.wardName, required super.nameExtension});

  factory WardModel.fromJson(Map<String, dynamic> json) => WardModel(
        wardCode: json["WardCode"],
        districtId: json["DistrictID"],
        wardName: json["WardName"],
        nameExtension: List<String>.from(json["NameExtension"].map((x) => x)),
      );
}
