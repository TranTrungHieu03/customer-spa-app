import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/data/model/product_cart_model.dart';
import 'package:spa_mobile/features/product/domain/repository/cart_repository.dart';

class GetCart implements UseCase<Either, NoParams> {
  final CartRepository _repository;

  GetCart(this._repository);

  @override
  Future<Either<Failure, List<ProductCartModel>>> call(NoParams params) async {
    return await _repository.getCartProducts();
  }
}
