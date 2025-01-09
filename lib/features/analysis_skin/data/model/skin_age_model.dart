import 'package:spa_mobile/features/analysis_skin/domain/entities/skin_age.dart';

class SkinAgeModel extends SkinAge {
  SkinAgeModel({required super.value});

  factory SkinAgeModel.fromJson(Map<String, dynamic> json) => SkinAgeModel(
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}
