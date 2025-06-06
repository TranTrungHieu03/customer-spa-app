import 'package:spa_mobile/features/service/data/model/category_model.dart';
import 'package:spa_mobile/features/service/domain/entities/service.dart';

class ServiceModel extends Service {
  final CategoryModel? serviceCategory;

  const ServiceModel(
      {required super.serviceId,
      required super.serviceCategoryId,
      required super.name,
      required super.description,
      required super.price,
      required super.duration,
      required super.status,
      required super.images,
      required super.steps,
      this.serviceCategory});

  // Factory method to parse JSON to Service object
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
        serviceId: json['serviceId'] as int,
        serviceCategoryId: json['serviceCategoryId'] ?? 0,
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        duration: json['duration'] as String,
        status: json['status'] as String,
        serviceCategory: json['serviceCategory'] != null ? CategoryModel.fromJson(json['serviceCategory']) : null,
        images: json['images'] is List ? (json['images'] as List<dynamic>).map((e) => e.toString()).toList() : [],
        steps: json['steps'] as String);
  }

  // Method to convert Service object to JSON
  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'status': status,
      'steps': steps,
      'images': (images as List).map((e) => e.toString()).toList(),
      'serviceCategoryId': serviceCategoryId
    };
  }

  factory ServiceModel.empty() {
    return const ServiceModel(
      serviceId: 0,
      name: '',
      description: '',
      price: 0.0,
      duration: "",
      status: "",
      serviceCategoryId: 0,
      steps: "",
      images: [],
    );
  }
}
