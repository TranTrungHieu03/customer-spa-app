import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/domain/entities/skin_age.dart';

class SkinAgeModel extends SkinAge {
  SkinAgeModel({required super.value});

  factory SkinAgeModel.fromJson(Map<String, dynamic> json) {
    AppLogger.info("fromJson SkinAgeModel $json");
    return SkinAgeModel(
      value: json["value"],
    );
  }

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}
