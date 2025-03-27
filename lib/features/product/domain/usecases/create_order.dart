import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/repository/order_repository.dart';

class ProductQuantity {
  final int productBranchId;
  final int quantity;
  final ProductModel product;

  const ProductQuantity({required this.quantity, required this.productBranchId, required this.product});

  Map<String, dynamic> toJson() {
    return {'productBranchId': productBranchId, 'quantity': quantity};
  }
}

class CreateOrderParams {
  final int userId;
  final int voucherId;
  final double totalAmount;
  final String paymentMethod;
  final List<ProductQuantity> products;

  const CreateOrderParams(
      {required this.userId, required this.totalAmount, required this.voucherId, required this.paymentMethod, required this.products});

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "voucherId": voucherId,
      "totalAmount": totalAmount,
      "paymentMethod": paymentMethod,
      "products": products.map((p) => p.toJson()).toList(),
    };
  }
}

class CreateOrder implements UseCase<Either, CreateOrderParams> {
  final OrderRepository _repository;

  CreateOrder(this._repository);

  @override
  Future<Either<Failure, int>> call(CreateOrderParams params) async {
    return await _repository.createOrder(params);
  }
}
