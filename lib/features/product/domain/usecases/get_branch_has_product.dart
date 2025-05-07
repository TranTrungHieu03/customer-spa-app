import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/product_repository.dart';

class GetBranchHasProductParams {
  final int productId;

  GetBranchHasProductParams(this.productId);
}

class GetBranchHasProduct implements UseCase<Either, GetBranchHasProductParams> {
  final ProductRepository _repository;

  GetBranchHasProduct(this._repository);

  @override
  Future<Either> call(GetBranchHasProductParams params) async {
    return await _repository.getBranchHasProduct(params);
  }
}
