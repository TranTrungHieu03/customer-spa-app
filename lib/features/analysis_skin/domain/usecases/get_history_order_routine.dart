import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/routine_repository.dart';

class GetHistoryOrderRoutineParams {
  final int page;
  final String status;

  GetHistoryOrderRoutineParams({required this.status, required this.page});
}

class GetHistoryOrderRoutine implements UseCase<Either, GetHistoryOrderRoutineParams> {
  final RoutineRepository _repository;

  GetHistoryOrderRoutine(this._repository);

  @override
  Future<Either> call(GetHistoryOrderRoutineParams params) async {
    return await _repository.getOrderRoutineHistory(params);
  }
}
