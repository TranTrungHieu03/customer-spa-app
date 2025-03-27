import 'package:equatable/equatable.dart';

class ProductCart extends Equatable {
  final int productCartId;
  final int quantity;
  final int stockQuantity;



  const ProductCart({
    required this.productCartId,
    required this.quantity,
    required this.stockQuantity,

  });

  @override
  List<Object?> get props => [productCartId, quantity];
}
