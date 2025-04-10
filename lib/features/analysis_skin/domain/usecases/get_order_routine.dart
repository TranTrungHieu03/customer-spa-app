import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/routine_repository.dart';

class GetOrderRoutineParams {
  final int orderId;

  GetOrderRoutineParams(this.orderId);
}

class GetOrderRoutine implements UseCase<Either, GetOrderRoutineParams> {
  final RoutineRepository _repository;

  GetOrderRoutine(this._repository);

  @override
  Future<Either> call(GetOrderRoutineParams params) async {
    return await _repository.getOrderRoutine(params);
  }
}
