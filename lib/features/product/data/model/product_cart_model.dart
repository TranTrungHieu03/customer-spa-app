import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/entities/product_cart.dart';

class ProductCartModel extends ProductCart {
  final ProductModel product;

  const ProductCartModel({
    required this.product,
    required super.productId,
    required super.quantity,
  });

  factory ProductCartModel.fromJson(Map<String, dynamic> json) {
    return ProductCartModel(
      product: ProductModel.fromJson(json['product']),
      productId: json['productId'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'productId': productId,
      'quantity': quantity,
    };
  }
}
