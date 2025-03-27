import 'package:spa_mobile/features/analysis_skin/data/model/product_routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/service_routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/entities/routine_step.dart';

class RoutineStepModel extends RoutineStep {
  final List<ServiceRoutineModel> serviceRoutineSteps;
  final List<ProductRoutineModel> productRoutineSteps;

  const RoutineStepModel({
    required super.skinCareRoutineStepId,
    required super.skincareRoutineId,
    required super.name,
    required super.step,
    required super.intervalBeforeNextStep,
    required this.productRoutineSteps,
    required this.serviceRoutineSteps,
  });

  factory RoutineStepModel.fromJson(Map<String, dynamic> json) {
    return RoutineStepModel(
      skinCareRoutineStepId: json['skinCareRoutineStepId'] as int,
      skincareRoutineId: json['skincareRoutineId'] as int,
      name: json['name'] != null ? json['name'] as String : "",
      step: json['step'] as int,
      intervalBeforeNextStep: json['intervalBeforeNextStep'] ?? "",
      productRoutineSteps: (json['productRoutineSteps'] as List<dynamic>?)
              ?.map((item) => ProductRoutineModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      serviceRoutineSteps: (json['serviceRoutineSteps'] as List<dynamic>?)
              ?.map((item) => ServiceRoutineModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
