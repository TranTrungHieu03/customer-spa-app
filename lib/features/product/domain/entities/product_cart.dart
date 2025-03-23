import 'package:equatable/equatable.dart';

class ProductCart extends Equatable {
  final String productId;
  final int quantity;

  const ProductCart({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}
