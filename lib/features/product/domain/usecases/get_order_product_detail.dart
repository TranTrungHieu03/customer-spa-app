import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/order_repository.dart';

class GetOrderProductDetailParams {
  final int id;

  GetOrderProductDetailParams({required this.id});
}

class GetOrderProductDetail implements UseCase<Either, GetOrderProductDetailParams> {
  final OrderRepository _repository;

  GetOrderProductDetail(this._repository);

  @override
  Future<Either> call(GetOrderProductDetailParams params) async {
    return await _repository.getOrderProductDetail(params);
  }
}
