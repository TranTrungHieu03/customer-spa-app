import 'package:spa_mobile/features/analysis_skin/data/model/acne_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/black_head_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_age_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_hua_he_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_tone_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_type_model.dart';

class SkinHealthModel {
  final BlackheadModel skinColor;
  final SkinAgeModel skinAge;
  final BlackheadModel leftEyelids;
  final BlackheadModel rightEyelids;
  final BlackheadModel eyePouch;
  final BlackheadModel darkCircle;
  final BlackheadModel foreheadWrinkle;
  final BlackheadModel crowsFeet;
  final BlackheadModel eyeFinelines;
  final BlackheadModel glabellaWrinkle;
  final BlackheadModel nasolabialFold;
  final BlackheadModel nasolabialFoldSeverity;
  final SkinTypeModel skinType;
  final BlackheadModel poresForehead;
  final BlackheadModel poresLeftCheek;
  final BlackheadModel poresRightCheek;
  final BlackheadModel poresJaw;
  final BlackheadModel blackhead;
  final AcneModel acne;
  final AcneModel mole;
  final AcneModel skinSpot;
  final AcneModel closedComedones;
  final SkintoneItaModel skintoneIta;
  final SkinHueHaModel skinHueHa;

  SkinHealthModel({
    required this.skinColor,
    required this.skinAge,
    required this.leftEyelids,
    required this.rightEyelids,
    required this.eyePouch,
    required this.darkCircle,
    required this.foreheadWrinkle,
    required this.crowsFeet,
    required this.eyeFinelines,
    required this.glabellaWrinkle,
    required this.nasolabialFold,
    required this.nasolabialFoldSeverity,
    required this.skinType,
    required this.poresForehead,
    required this.poresLeftCheek,
    required this.poresRightCheek,
    required this.poresJaw,
    required this.blackhead,
    required this.acne,
    required this.mole,
    required this.skinSpot,
    required this.closedComedones,
    required this.skintoneIta,
    required this.skinHueHa,
  });

  factory SkinHealthModel.fromJson(Map<String, dynamic> json) =>
      SkinHealthModel(
        skinColor: BlackheadModel.fromJson(json["skin_color"]),
        skinAge: SkinAgeModel.fromJson(json["skin_age"]),
        leftEyelids: BlackheadModel.fromJson(json["left_eyelids"]),
        rightEyelids: BlackheadModel.fromJson(json["right_eyelids"]),
        eyePouch: BlackheadModel.fromJson(json["eye_pouch"]),
        darkCircle: BlackheadModel.fromJson(json["dark_circle"]),
        foreheadWrinkle: BlackheadModel.fromJson(json["forehead_wrinkle"]),
        crowsFeet: BlackheadModel.fromJson(json["crows_feet"]),
        eyeFinelines: BlackheadModel.fromJson(json["eye_finelines"]),
        glabellaWrinkle: BlackheadModel.fromJson(json["glabella_wrinkle"]),
        nasolabialFold: BlackheadModel.fromJson(json["nasolabial_fold"]),
        nasolabialFoldSeverity:
            BlackheadModel.fromJson(json["nasolabial_fold_severity"]),
        skinType: SkinTypeModel.fromJson(json["skin_type"]),
        poresForehead: BlackheadModel.fromJson(json["pores_forehead"]),
        poresLeftCheek: BlackheadModel.fromJson(json["pores_left_cheek"]),
        poresRightCheek: BlackheadModel.fromJson(json["pores_right_cheek"]),
        poresJaw: BlackheadModel.fromJson(json["pores_jaw"]),
        blackhead: BlackheadModel.fromJson(json["blackhead"]),
        acne: AcneModel.fromJson(json["acne"]),
        mole: AcneModel.fromJson(json["mole"]),
        skinSpot: AcneModel.fromJson(json["skin_spot"]),
        closedComedones: AcneModel.fromJson(json["closed_comedones"]),
        skintoneIta: SkintoneItaModel.fromJson(json["skintone_ita"]),
        skinHueHa: SkinHueHaModel.fromJson(json["skin_hue_ha"]),
      );

  Map<String, dynamic> toJson() => {
        "skin_color": skinColor.toJson(),
        "skin_age": skinAge.toJson(),
        "left_eyelids": leftEyelids.toJson(),
        "right_eyelids": rightEyelids.toJson(),
        "eye_pouch": eyePouch.toJson(),
        "dark_circle": darkCircle.toJson(),
        "forehead_wrinkle": foreheadWrinkle.toJson(),
        "crows_feet": crowsFeet.toJson(),
        "eye_finelines": eyeFinelines.toJson(),
        "glabella_wrinkle": glabellaWrinkle.toJson(),
        "nasolabial_fold": nasolabialFold.toJson(),
        "nasolabial_fold_severity": nasolabialFoldSeverity.toJson(),
        "skin_type": skinType.toJson(),
        "pores_forehead": poresForehead.toJson(),
        "pores_left_cheek": poresLeftCheek.toJson(),
        "pores_right_cheek": poresRightCheek.toJson(),
        "pores_jaw": poresJaw.toJson(),
        "blackhead": blackhead.toJson(),
        "acne": acne.toJson(),
        "mole": mole.toJson(),
        "skin_spot": skinSpot.toJson(),
        "closed_comedones": closedComedones.toJson(),
        "skintone_ita": skintoneIta.toJson(),
        "skin_hue_ha": skinHueHa.toJson(),
      };
}
