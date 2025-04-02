import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/product/data/model/list_order_product_model.dart';
import 'package:spa_mobile/features/product/data/model/order_product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_history_product.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_order_product_detail.dart';

abstract class OrderRepository {
  Future<Either<Failure, int>> createOrder(CreateOrderParams params);

  Future<Either<Failure, ListOrderProductModel>> getHistoryProduct(GetHistoryProductParams params);

  Future<Either<Failure, OrderProductModel>> getOrderProductDetail(GetOrderProductDetailParams params);
}
