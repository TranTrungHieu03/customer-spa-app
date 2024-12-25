import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/network/connection_checker.dart';
import 'package:spa_mobile/features/service/data/datasources/service_remote_data_source.dart';
import 'package:spa_mobile/features/service/data/model/list_service_model.dart';
import 'package:spa_mobile/features/service/domain/entities/service.dart';
import 'package:spa_mobile/features/service/domain/repository/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSrc _serviceRemoteDataSrc;
  final ConnectionChecker _connectionChecker;

  ServiceRepositoryImpl(this._serviceRemoteDataSrc, this._connectionChecker);

  @override
  Future<Either<Failure, Service>> getServiceDetail() {
    // TODO: implement getServiceDetail
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, ListServiceModel>> getServices(int param) async {
    try {
      ListServiceModel result =
          await _serviceRemoteDataSrc.getServices(param);

      return right(result);
    } on AppException catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }
}
