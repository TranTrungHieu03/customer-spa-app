import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_health_model.dart';

class SkinHealthStatisticModel {
  final SkinHealthModel skinHealth;
  // final String imageUrl;
  // final DateTime createdDate;
  // final DateTime updatedDate;

  SkinHealthStatisticModel({
    required this.skinHealth,
    // required this.imageUrl,
    // required this.createdDate,
    // required this.updatedDate,
  });

  factory SkinHealthStatisticModel.fromJson(Map<String, dynamic> json) {
    AppLogger.wtf(json);
    return SkinHealthStatisticModel(
      skinHealth: SkinHealthModel.fromJsonDB(json),
      // imageUrl: json['imageUrl'],
      // createdDate: DateTime.parse(json['createdDate']),
      // updatedDate: DateTime.parse(json['updatedDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skinHealth': skinHealth.toJson(),
      // 'imageUrl': imageUrl,
      // 'createdDate': createdDate.toIso8601String(),
      // 'updatedDate': updatedDate.toIso8601String(),
    };
  }
}
