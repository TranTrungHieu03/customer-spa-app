import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/domain/entities/black_head.dart';

class BlackheadModel extends Blackhead {
  BlackheadModel({required super.value, required super.confidence});

  factory BlackheadModel.fromJson(Map<String, dynamic> json) {
    AppLogger.info("fromJson BlackheadModel $json");
    return BlackheadModel(
      value: json["value"],
      confidence: json["confidence"].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "value": value,
        "confidence": confidence,
      };
}
