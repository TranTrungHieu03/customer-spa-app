import 'package:spa_mobile/features/product/domain/entities/product_category.dart';

class ProductCategoryModel extends ProductCategory {
  const ProductCategoryModel(
      {required super.categoryId, required super.name, required super.description, required super.status, required super.imageUrl});

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      categoryId: json['categoryId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      imageUrl: json['imageUrl'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'status': status,
      'imageUrl': imageUrl,
    };
  }
}
