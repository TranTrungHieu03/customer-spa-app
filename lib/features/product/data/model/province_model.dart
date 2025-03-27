import 'package:spa_mobile/features/product/domain/entities/province.dart';

class ProvinceModel extends Province {
  const ProvinceModel({required super.provinceId, required super.provinceName, required super.countryId, required super.nameExtension});

  factory ProvinceModel.fromJson(Map<String, dynamic> json) => ProvinceModel(
        provinceId: json["ProvinceID"],
        provinceName: json["ProvinceName"],
        countryId: json["CountryID"],
        nameExtension: List<String>.from(json["NameExtension"].map((x) => x)),
      );
}
