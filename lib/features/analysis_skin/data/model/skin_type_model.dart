import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/black_head_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/entities/skin_type.dart';

class SkinTypeModel extends SkinType {
  SkinTypeModel({required super.skinType, required super.details});

  factory SkinTypeModel.fromJson(Map<String, dynamic> json) {
    AppLogger.info("fromJson SkinTypeModel $json");
    return SkinTypeModel(
      skinType: json["skin_type"],
      details: List<BlackheadModel>.from(json["details"].map((x) => BlackheadModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "skin_type": skinType,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}
