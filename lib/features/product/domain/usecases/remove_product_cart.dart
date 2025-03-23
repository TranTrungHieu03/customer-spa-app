import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/cart_repository.dart';

class RemoveProductCart implements UseCase<Either, String> {
  final CartRepository _repository;

  RemoveProductCart(this._repository);

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await _repository.removeProductFromCart(params);
  }
}
