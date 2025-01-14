import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/product/domain/entities/product.dart';
import 'package:spa_mobile/features/service/data/model/category_model.dart';

class ProductModel extends Product {
  final CategoryModel category;

  ProductModel(
      {required super.productId,
      required super.productName,
      required super.skinTypeSuitable,
      required super.productDescription,
      required super.price,
      required super.dimension,
      required super.quantity,
      required super.discount,
      required super.status,
      required super.categoryId,
      required this.category,
      required super.companyId,
      required super.volume,
      required super.images});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    AppLogger.debug(json);
    return ProductModel(
      skinTypeSuitable: json['skinTypeSuitable'],
      productId: json['productId'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      price: json['price'],
      dimension: json['dimension'],
      quantity: json['quantity'],
      volume: json['volume'],
      discount: json['discount'],
      status: json['status'],
      categoryId: json['categoryId'],
      companyId: json['companyId'],
      category: CategoryModel.fromJson(json['category']),
      images: (json['images'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productDescription': productDescription,
      'price': price,
      'volume': volume,
      'quantity': quantity,
      'dimension': dimension,
      'discount': discount,
      'status': status,
      'categoryId': categoryId,
      'skinTypeSuitable': skinTypeSuitable,
      'companyId': companyId,
      'category': category.toJson(),
      'images': (images as List).map((e) => e.toString()).toList(),
    };
  }

  Product copyWith(
          {int? productId,
          String? productName,
          String? productDescription,
          double? price,
          double? volume,
          int? quantity,
          double? discount,
          String? status,
          String? dimension,
          int? categoryId,
          int? companyId,
          String? skinTypeSuitable,
          CategoryModel? category,
          List<String>? images}) =>
      ProductModel(
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        productDescription: productDescription ?? this.productDescription,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        discount: discount ?? this.discount,
        dimension: dimension ?? this.dimension,
        volume: volume ?? this.volume,
        skinTypeSuitable: skinTypeSuitable ?? this.skinTypeSuitable,
        status: status ?? this.status,
        categoryId: categoryId ?? this.categoryId,
        companyId: companyId ?? this.companyId,
        category: category ?? this.category,
        images: images ?? List.from(this.images),
      );
}
