import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/entities/product_cart.dart';

class ProductCartModel extends ProductCart {
  final ProductModel product;

  const ProductCartModel({required this.product, required super.productCartId, required super.quantity});

  factory ProductCartModel.fromJson(Map<String, dynamic> json) {
    return ProductCartModel(
      product: ProductModel.fromJson(json['product']),
      productCartId: json['productCartId'],
      quantity: json['quantity'],
      // quantity: 1,
      // stockQuantity: json['stockQuantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'productCartId': productCartId,
      'quantity': quantity,
    };
  }

  ProductCartModel copyWith({ProductModel? product, int? quantity, int? productCartId}) {
    return ProductCartModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      productCartId: productCartId ?? this.productCartId,
    );
  }
}
