import 'package:spa_mobile/features/product/domain/entities/product.dart';
import 'package:spa_mobile/features/service/data/model/category_model.dart';

class ProductModel extends Product {
  final CategoryModel category;

  ProductModel(
      {required super.productId,
      required super.productName,
      required super.productDescription,
      required super.price,
      required super.dimension,
      required super.quantity,
      required super.discount,
      required super.status,
      required super.categoryId,
      required this.category,
      required super.companyId});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      price: json['price'],
      dimension: json['dimension'],
      quantity: json['quantity'],
      discount: json['discount'],
      status: json['status'],
      categoryId: json['categoryId'],
      companyId: json['companyId'],
      category: CategoryModel.fromJson(json['category']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productDescription': productDescription,
      'price': price,
      'quantity': quantity,
      'dimension': dimension,
      'discount': discount,
      'status': status,
      'categoryId': categoryId,
      'companyId': companyId,
      'category': category,
    };
  }

  Product copyWith({
    int? productId,
    String? productName,
    String? productDescription,
    double? price,
    int? quantity,
    double? discount,
    String? status,
    String? dimension,
    int? categoryId,
    int? companyId,
    CategoryModel? category,
  }) =>
      ProductModel(
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        productDescription: productDescription ?? this.productDescription,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        discount: discount ?? this.discount,
        dimension: dimension ?? this.dimension,
        status: status ?? this.status,
        categoryId: categoryId ?? this.categoryId,
        companyId: companyId ?? this.companyId,
        category: category ?? this.category,
      );
}
