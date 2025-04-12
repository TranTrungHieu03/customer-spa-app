import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/product_repository.dart';

class ListProductFeedbackParams {
  final int productId;

  ListProductFeedbackParams(this.productId);
}

class GetListProductFeedback implements UseCase<Either, ListProductFeedbackParams> {
  final ProductRepository _repository;

  GetListProductFeedback(this._repository);

  @override
  Future<Either> call(ListProductFeedbackParams params) async {
    return await _repository.getListFeedback(params);
  }
}
