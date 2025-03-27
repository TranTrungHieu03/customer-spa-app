import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/entities/product_cart.dart';

class ProductCartModel extends ProductCart {
  final ProductModel product;

  const ProductCartModel({required this.product, required super.productCartId, required super.quantity, required super.stockQuantity});

  factory ProductCartModel.fromJson(Map<String, dynamic> json) {
    return ProductCartModel(
      product: ProductModel.fromJson(json['product']),
      productCartId: json['productCartId'],
      // quantity: json['quantity'] ?? 1,
      quantity: 1,
      stockQuantity: json['stockQuantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'productCartId': productCartId,
      'quantity': quantity,
    };
  }
}
