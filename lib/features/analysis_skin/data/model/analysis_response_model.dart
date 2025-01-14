import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_health_model.dart';

class AnalysisResponseModel {
  final SkinHealthModel skinhealth;
  final List<RoutineModel> routines;

  AnalysisResponseModel({required this.skinhealth, required this.routines});

  factory AnalysisResponseModel.fromJson(Map<String, dynamic> json) {
    AppLogger.info("fromJson AnalysisResponseModel $json");
    return AnalysisResponseModel(
      skinhealth: SkinHealthModel.fromJson(json['skinhealth']),
      routines: List<RoutineModel>.from(json['routines'].map((x) => RoutineModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skinhealth': skinhealth.toJson(),
      'routines': List<dynamic>.from(routines.map((x) => x.toJson())),
    };
  }
}
