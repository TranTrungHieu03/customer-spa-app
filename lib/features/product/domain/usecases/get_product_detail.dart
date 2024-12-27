import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/repository/product_repository.dart';

class GetProductDetail implements UseCase<Either, GetProductDetailParams> {
  final ProductRepository _productRepository;

  GetProductDetail(this._productRepository);

  @override
  Future<Either<Failure, ProductModel>> call(
      GetProductDetailParams params) async {
    return await _productRepository.getProduct(params.productId);
  }
}

class GetProductDetailParams {
  final int productId;

  GetProductDetailParams(this.productId);
}
