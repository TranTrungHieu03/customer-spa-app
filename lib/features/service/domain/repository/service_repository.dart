import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/service/data/model/list_service_model.dart';
import 'package:spa_mobile/features/service/domain/entities/service.dart';

abstract class ServiceRepository {
  const ServiceRepository();

  Future<Either<Failure, ListServiceModel>> getServices(int param);

  Future<Either<Failure, Service>> getServiceDetail();
}
