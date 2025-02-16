import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/rectangle_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/entities/acne.dart';

class AcneModel extends Acne {
  AcneModel({required super.rectangle, required super.length});

  factory AcneModel.fromJson(Map<String, dynamic> json) {
    AppLogger.info("fromJson AcneModel $json");
    return AcneModel(
      rectangle: json["rectangle"] == null || json["rectangle"] is! List
          ? []
          : List<RectangleModel>.from(json["rectangle"].map((x) => RectangleModel.fromJson(x))),
      length: json["length"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {"rectangle": List<dynamic>.from(rectangle.map((x) => x.toJson())), "length": length};
}
