import 'package:equatable/equatable.dart';

class ProductCart extends Equatable {
  final int productCartId;
  final int quantity;

  const ProductCart({
    required this.productCartId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productCartId, quantity];
}
