import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/domain/repository/service_repository.dart';

class GetServiceDetail implements UseCase<Either, GetServiceDetailParams> {
  final ServiceRepository _serviceRepository;

  GetServiceDetail(this._serviceRepository);

  @override
  Future<Either<Failure, ServiceModel>> call(GetServiceDetailParams params) async {
    return await _serviceRepository.getServiceDetail(params);
  }
}

class GetServiceDetailParams {
  final int id;

  GetServiceDetailParams({required this.id});
}
