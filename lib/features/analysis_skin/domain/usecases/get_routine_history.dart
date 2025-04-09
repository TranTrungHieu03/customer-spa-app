import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/routine_repository.dart';

class GetRoutineHistoryParams {
  final String status;
  final int userId;

  GetRoutineHistoryParams({required this.userId, required this.status});
}

class GetHistoryRoutine implements UseCase<Either, GetRoutineHistoryParams> {
  final RoutineRepository _repository;

  GetHistoryRoutine(this._repository);

  @override
  Future<Either> call(GetRoutineHistoryParams params) async {
    return await _repository.getHistoryRoutine(params);
  }
}
