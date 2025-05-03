import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/routine_repository.dart';

class GetFeedbackStepParams {
  final int userRoutineId;

  GetFeedbackStepParams(this.userRoutineId);
}

class GetFeedbackStep implements UseCase<Either, GetFeedbackStepParams> {
  final RoutineRepository _repository;

  GetFeedbackStep(this._repository);

  @override
  Future<Either> call(GetFeedbackStepParams params) async {
    return await _repository.getFeedbackSteps(params);
  }
}
