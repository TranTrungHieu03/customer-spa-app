import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/order_repository.dart';

class GetHistoryProductParams {
  final int page;
  final String status;

  GetHistoryProductParams({required this.page, required this.status});
}

class GetHistoryProduct implements UseCase<Either, GetHistoryProductParams> {
  final OrderRepository _repository;

  GetHistoryProduct(this._repository);

  @override
  Future<Either> call(GetHistoryProductParams params) async {
    return await _repository.getHistoryProduct(params);
  }
}
