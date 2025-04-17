import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';

class ProductRoutineModel {
  final int id;
  final int step;
  final ProductModel product;

  ProductRoutineModel({required this.id, required this.step, required this.product});

  factory ProductRoutineModel.fromJson(Map<String, dynamic> json) {
    AppLogger.info(json);
    return ProductRoutineModel(id: json['id'] as int, step: json['stepId'] as int, product: ProductModel.fromJson(json['product']));
  }
}
