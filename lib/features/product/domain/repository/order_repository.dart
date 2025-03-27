import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';

abstract class OrderRepository{
  Future<Either<Failure, int>> createOrder(CreateOrderParams params);
}