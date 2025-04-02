import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/product/data/datasources/order_remote_data_source.dart';
import 'package:spa_mobile/features/product/data/model/list_order_product_model.dart';
import 'package:spa_mobile/features/product/data/model/order_product_model.dart';
import 'package:spa_mobile/features/product/domain/repository/order_repository.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_history_product.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_order_product_detail.dart';

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

  @override
  Future<Either<Failure, ListOrderProductModel>> getHistoryProduct(GetHistoryProductParams params) async {
    try {
      ListOrderProductModel result = await _dataSource.getHistoryProduct(params);
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, OrderProductModel>> getOrderProductDetail(GetOrderProductDetailParams params) async {
    try {
      OrderProductModel result = await _dataSource.getOrderProductModel(params);
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }
}
