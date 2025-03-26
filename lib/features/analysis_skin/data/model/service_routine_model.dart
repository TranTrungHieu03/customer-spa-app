import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';

class ServiceRoutineModel {
  final int id;
  final int step;
  final ServiceModel service;

  const ServiceRoutineModel({required this.id, required this.step, required this.service});

  factory ServiceRoutineModel.fromJson(Map<String, dynamic> json) {
    return ServiceRoutineModel(id: json['id'] as int, step: json['stepId'] as int, service: ServiceModel.fromJson(json['service']));
  }
}
