import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';

class ListServiceProductModel {
  final List<ServiceModel> services;
  final List<ProductModel> products;

  ListServiceProductModel({
    required this.services,
    required this.products,
  });

  factory ListServiceProductModel.fromJson(Map<String, dynamic> json) {
    return ListServiceProductModel(
      services: (json['services'] as List<dynamic>).map((e) => ServiceModel.fromJson(e as Map<String, dynamic>)).toList(),
      products: (json['products'] as List<dynamic>).map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
