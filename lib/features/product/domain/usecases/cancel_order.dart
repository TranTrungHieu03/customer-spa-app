import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/order_repository.dart';

class CancelOrderParams {
  final int orderId;
  final String reason;

  CancelOrderParams({required this.orderId, required this.reason});

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'reason': reason,
    };
  }
}

class CancelOrder implements UseCase<Either, CancelOrderParams> {
  final OrderRepository _repository;

  CancelOrder(this._repository);

  @override
  Future<Either> call(CancelOrderParams params) async {
    return await _repository.cancelOrder(params);
  }
}
