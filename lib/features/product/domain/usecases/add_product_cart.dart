import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/cart_repository.dart';

class AddProductCart implements UseCase<Either, AddProductCartParams> {
  final CartRepository _repository;

  AddProductCart(this._repository);

  @override
  Future<Either<Failure, String>> call(AddProductCartParams params) async {
    if (kDebugMode){
      AppLogger.info(params);
    }
    return await _repository.addProductToCart(params);
  }
}

class AddProductCartParams {
  final int productId;
  final int quantity;
  final int operation;

  AddProductCartParams({required this.productId, required this.quantity, required this.operation});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddProductCartParams && other.productId == productId && other.quantity == quantity && other.operation == operation;
  }

  @override
  int get hashCode {
    return productId.hashCode ^ quantity.hashCode ^ operation.hashCode;
  }

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'quantity': quantity, 'operation': operation};
  }
}
