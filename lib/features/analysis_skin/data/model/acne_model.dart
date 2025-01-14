import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/rectangle_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/entities/acne.dart';

class AcneModel extends Acne {
  AcneModel({required super.rectangle, required super.length});

  factory AcneModel.fromJson(Map<String, dynamic> json) {
    AppLogger.info("fromJson AcneModel $json");
    return AcneModel(
        rectangle: List<RectangleModel>.from(json["rectangle"].map((x) => RectangleModel.fromJson(x))), length: json["length"]);
  }

  Map<String, dynamic> toJson() => {"rectangle": List<dynamic>.from(rectangle.map((x) => x.toJson())), "length": length};
}
