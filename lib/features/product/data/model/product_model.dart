import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/features/product/data/model/product_category_model.dart';
import 'package:spa_mobile/features/product/domain/entities/product.dart';

class ProductModel extends Product {
  final ProductCategoryModel? category;
  final BranchModel? branch;

  ProductModel(
      {required super.productId,
      required super.productName,
      required super.skinTypeSuitable,
      required super.productDescription,
      required super.price,
      required super.dimension,
      required super.brand,
      required super.quantity,
      required super.branchId,
      required super.discount,
      required super.status,
      required super.categoryId,
      this.category,
      required super.companyId,
      required super.productBranchId,
      required super.stockQuantity,
      required super.volume,
      this.branch,
      required super.images});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      skinTypeSuitable: json['skinTypeSuitable'],
      productId: json['productId'],
      productName: json['productName'],
      brand: json['brand'] ?? "",
      productDescription: json['productDescription'],
      price: json['price'],
      dimension: json['dimension'],
      quantity: json['quantity'],
      volume: json['volume'],
      discount: json['discount'],
      status: json['status'],
      categoryId: json['categoryId'],
      companyId: json['companyId'],
      branchId: json['brandId'] ?? 0,
      stockQuantity: json['stockQuantity'] ?? 0,
      productBranchId: json['productBranchId'] ?? 0,
      category: json['category'] != null ? ProductCategoryModel.fromJson(json['category']) : null,
      images: (json['images'] is List) ? (json['images'] as List).map((e) => e.toString()).toList() : [],
      branch: json['branches'] != null ? BranchModel.fromJson(json['branches']) : null,
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
      'brand': brand,
      'categoryId': categoryId,
      'skinTypeSuitable': skinTypeSuitable,
      'companyId': companyId,
      'images': (images as List).map((e) => e.toString()).toList(),
    };
  }
//
// Product copyWith(
//         {int? productId,
//         String? productName,
//         String? productDescription,
//         double? price,
//         double? volume,
//         int? quantity,
//         double? discount,
//         String? status,
//         String? dimension,
//         int? categoryId,
//         int? companyId,
//         String? skinTypeSuitable,
//         CategoryModel? category,
//         List<String>? images}) =>
//     ProductModel(
//       productId: productId ?? this.productId,
//       productName: productName ?? this.productName,
//       productDescription: productDescription ?? this.productDescription,
//       price: price ?? this.price,
//       quantity: quantity ?? this.quantity,
//       discount: discount ?? this.discount,
//       dimension: dimension ?? this.dimension,
//       volume: volume ?? this.volume,
//       skinTypeSuitable: skinTypeSuitable ?? this.skinTypeSuitable,
//       status: status ?? this.status,
//       categoryId: categoryId ?? this.categoryId,
//       companyId: companyId ?? this.companyId,
//       category: category ?? this.category,
//       images: images ?? List.from(this.images),
//     );
}
