import 'package:spa_mobile/features/analysis_skin/domain/entities/skin_tone.dart';

class SkintoneItaModel extends SkintoneIta {
  SkintoneItaModel({required super.ita, required super.skintone});

  factory SkintoneItaModel.fromJson(Map<String, dynamic> json) =>
      SkintoneItaModel(
        ita: json["ITA"].toDouble(),
        skintone: json["skintone"],
      );

  Map<String, dynamic> toJson() => {
        "ITA": ita,
        "skintone": skintone,
      };
}
