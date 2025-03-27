import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/product/data/datasources/order_remote_data_source.dart';
import 'package:spa_mobile/features/product/domain/repository/order_repository.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _dataSource;

  const OrderRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, int>> createOrder(CreateOrderParams params) async {
    try {
      int result = await _dataSource.createOrder(params);
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }
}
