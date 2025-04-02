import 'package:spa_mobile/features/product/domain/entities/district.dart';

class DistrictModel extends District {
  const DistrictModel({required super.districtId, required super.provinceId, required super.districtName });

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
        districtId: json["DistrictID"],
        provinceId: json["ProvinceID"],
        districtName: json["DistrictName"],
      );
}
