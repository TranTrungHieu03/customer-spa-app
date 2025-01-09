import 'package:spa_mobile/features/analysis_skin/domain/entities/skin_hua_he.dart';

class SkinHueHaModel extends SkinHueHa {
  SkinHueHaModel({required super.ha, required super.skinHue});

  factory SkinHueHaModel.fromJson(Map<String, dynamic> json) => SkinHueHaModel(
        ha: json["HA"].toDouble(),
        skinHue: json["skin_hue"],
      );

  Map<String, dynamic> toJson() => {
        "HA": ha,
        "skin_hue": skinHue,
      };
}
