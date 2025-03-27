import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/data/model/product_cart_model.dart';
import 'package:spa_mobile/features/product/domain/repository/cart_repository.dart';

class AddProductCart implements UseCase<Either, AddProductCartParams> {
  final CartRepository _repository;

  AddProductCart(this._repository);

  @override
  Future<Either<Failure, List<ProductCartModel>>> call(AddProductCartParams params) async {
    if (kDebugMode) {
      AppLogger.info(params);
    }
    return await _repository.addProductToCart(params);
  }
}

class AddProductCartParams {
  final int productId;
  final int quantity;
  final int operation;
  final int userId;

  AddProductCartParams({required this.productId, required this.quantity, required this.operation, required this.userId});

  Map<String, dynamic> toJson() {
    return {'productBranchId': productId, 'quantity': quantity, 'operation': operation, 'userId': userId};
  }
}
