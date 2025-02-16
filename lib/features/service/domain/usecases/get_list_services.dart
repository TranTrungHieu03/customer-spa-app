import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/domain/repository/service_repository.dart';

class GetListService implements UseCase<Either, GetListServiceParams> {
  final ServiceRepository _serviceRepository;

  GetListService(this._serviceRepository);

  @override
  Future<Either> call(GetListServiceParams param) async {
    if (param.branchId == 0) {
      return await _serviceRepository.getServices(param);
    } else {
      return await _serviceRepository.getServicesByBranch(param);
    }
  }
}

class GetListServiceParams {
  final int page;
  final int branchId;

  GetListServiceParams(this.page, this.branchId);
}
