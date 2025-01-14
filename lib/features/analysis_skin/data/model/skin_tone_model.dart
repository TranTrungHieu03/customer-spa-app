import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/domain/entities/skin_tone.dart';

class SkintoneItaModel extends SkintoneIta {
  SkintoneItaModel({required super.ita, required super.skintone});

  factory SkintoneItaModel.fromJson(Map<String, dynamic> json) {
    AppLogger.info("fromJson SkintoneItaModel $json");
    return SkintoneItaModel(
      ita: json["ITA"].toDouble(),
      skintone: json["skintone"],
    );
  }

  Map<String, dynamic> toJson() => {
        "ITA": ita,
        "skintone": skintone,
      };
}
