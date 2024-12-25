import 'package:spa_mobile/features/service/data/model/category_model.dart';
import 'package:spa_mobile/features/service/domain/entities/service.dart';

class ServiceModel extends Service {
  final CategoryModel category;

  const ServiceModel(
      {required super.serviceId,
      required super.name,
      required super.description,
      required super.price,
      required super.duration,
      // required super.status,
      required super.categoryId,
      required this.category});

  // Factory method to parse JSON to Service object
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
        serviceId: json['serviceId'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        duration: json['duration'] as String,
        // status: json['status'] as String,
        categoryId: json['categoryId'] as int,
        category:
            CategoryModel.fromJson(json['category'] as Map<String, dynamic>));
  }

  // Method to convert Service object to JSON
  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      // 'status': status,
      'categoryId': categoryId,
      'category': category
    };
  }
}
