import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/data/model/list_product_model.dart';
import 'package:spa_mobile/features/product/domain/repository/product_repository.dart';

class GetListProducts implements UseCase<Either, int> {
  final ProductRepository _productRepository;

  GetListProducts(this._productRepository);

  @override
  Future<Either<Failure, ListProductModel>> call(int params) async {
    return await _productRepository.getProducts(params);
  }
}
