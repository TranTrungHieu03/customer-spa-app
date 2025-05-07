import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/product_repository.dart';

class GetProductByProductId implements UseCase<Either, int> {
  final ProductRepository _repository;

  GetProductByProductId(this._repository);

  @override
  Future<Either> call(int params) async {
    return await _repository.getProductByProductId(params);
  }
}
