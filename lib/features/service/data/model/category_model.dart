import 'package:spa_mobile/features/service/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel(
      {required super.categoryId, required super.name, required super.description, required super.status, required super.imageUrl});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['categoryId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      imageUrl: json['imageUrl'] as String,
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
