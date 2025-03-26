import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_step_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_detail.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_step.dart';

abstract class RoutineRepository {
  Future<Either<Failure, List<RoutineModel>>> getListSkinCareRoutine();

  Future<Either<Failure, List<RoutineStepModel>>> getSkinCareRoutineStep(GetRoutineStepParams params);

  Future<Either<Failure, RoutineModel>> getRoutineDetail(GetRoutineDetailParams params);
}
