import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/domain/repository/service_repository.dart';

class GetListFeedbackServiceParams {
  final int serviceId;

  GetListFeedbackServiceParams(this.serviceId);
}

class GetListServiceFeedback implements UseCase<Either, GetListFeedbackServiceParams> {
  final ServiceRepository _repository;

  GetListServiceFeedback(this._repository);

  @override
  Future<Either> call(GetListFeedbackServiceParams params) async {
    return await _repository.getFeedbackServices(params);
  }
}
