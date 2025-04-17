import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/domain/entities/routine.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';

class RoutineModel extends Routine {
  final List<ProductModel> productRoutines;
  final List<ServiceModel> serviceRoutines;

  RoutineModel(
      {required super.skincareRoutineId,
      required super.name,
      required super.description,
      required super.totalSteps,
      required super.totalPrice,
      required super.targetSkinTypes,
      required this.productRoutines,
      required this.serviceRoutines});

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    AppLogger.info("fromJson RoutineModel $json");
    return RoutineModel(
      skincareRoutineId: json['skincareRoutineId'],
      name: json['name'],
      description: json['description'],
      totalSteps: json['totalSteps'],
      totalPrice: json['totalPrice'],
      targetSkinTypes: json['targetSkinTypes'],
      productRoutines: List<ProductModel>.from(json['productRoutines'].map((x) => ProductModel.fromJson(x['products']))),
      serviceRoutines: List<ServiceModel>.from(json['serviceRoutines'].map((x) => ServiceModel.fromJson(x['service']))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'skincareRoutineId': skincareRoutineId,
      'name': name,
      'description': description,
      'totalSteps': totalSteps,
      'targetSkinTypes': targetSkinTypes,
      'productRoutines': productRoutines != null ? List<dynamic>.from(productRoutines!.map((x) => x.toJson())) : null,
      'serviceRoutines': serviceRoutines != null ? List<dynamic>.from(serviceRoutines!.map((x) => x.toJson())) : null,
    };
  }
}
