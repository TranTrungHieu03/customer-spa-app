import 'package:spa_mobile/features/analysis_skin/domain/entities/routine.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';

class RoutineModel extends Routine {
  final List<ProductModel>? productRoutines;
  final List<ServiceModel>? serviceRoutines;

  RoutineModel(
      {required super.skincareRoutineId,
      required super.name,
      required super.description,
      required super.steps,
      required super.frequency,
      required super.targetSkinTypes,
      this.productRoutines,
      this.serviceRoutines});

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    return RoutineModel(
      skincareRoutineId: json['skincare_routine_id'],
      name: json['name'],
      description: json['description'],
      steps: json['steps'],
      frequency: json['frequency'],
      targetSkinTypes: json['target_skin_types'],
      productRoutines: json['product_routines'] != null
          ? List<ProductModel>.from(
              json['product_routines'].map((x) => ProductModel.fromJson(x)))
          : null,
      serviceRoutines: json['service_routines'] != null
          ? List<ServiceModel>.from(
              json['service_routines'].map((x) => ServiceModel.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skincare_routine_id': skincareRoutineId,
      'name': name,
      'description': description,
      'steps': steps,
      'frequency': frequency,
      'target_skin_types': targetSkinTypes,
      'product_routines': productRoutines != null
          ? List<dynamic>.from(productRoutines!.map((x) => x.toJson()))
          : null,
      'service_routines': serviceRoutines != null
          ? List<dynamic>.from(serviceRoutines!.map((x) => x.toJson()))
          : null,
    };
  }
}
