import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_step_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/routine_repository.dart';

class GetRoutineStepParams {
  int id;

  GetRoutineStepParams(this.id);
}

class GetRoutineStep implements UseCase<Either, GetRoutineStepParams> {
  final RoutineRepository routineRepository;

  GetRoutineStep(this.routineRepository);

  @override
  Future<Either<Failure, List<RoutineStepModel>>> call(GetRoutineStepParams params) async {
    return await routineRepository.getSkinCareRoutineStep(params);
  }
}
