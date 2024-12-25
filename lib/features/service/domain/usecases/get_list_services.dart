import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/domain/repository/service_repository.dart';

class GetListService implements UseCase<Either, int> {
  final ServiceRepository _serviceRepository;

  GetListService(this._serviceRepository);

  @override
  Future<Either> call(int param) async {
    return await _serviceRepository.getServices(param);
  }
}
