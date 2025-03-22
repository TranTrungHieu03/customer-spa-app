import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/cart_repository.dart';

// class AddProductCart implements UseCase<Either, AddProductCartParams> {
  // final CartRepository repository;
  //
  // AddProductCart({required this.repository});
  //
  // @override
  // Future<Either<Failure, int>> call(AddProductCartParams params) async {
  //   return await repository.addProductToCart(params);
  // }
// }

class AddProductCartParams {
  final int productId;
  final int quantity;
  final int status;
  final int operation;

  AddProductCartParams({required this.productId, required this.quantity, required this.status, required this.operation});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddProductCartParams &&
        other.productId == productId &&
        other.quantity == quantity &&
        other.status == status &&
        other.operation == operation;
  }

  @override
  int get hashCode {
    return productId.hashCode ^ quantity.hashCode ^ status.hashCode ^ operation.hashCode;
  }

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'quantity': quantity, 'status': status, 'operation': operation};
  }
}
