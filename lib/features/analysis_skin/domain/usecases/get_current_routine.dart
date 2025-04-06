import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/routine_repository.dart';

class GetCurrentRoutineParams {
  final int userId;

  GetCurrentRoutineParams(this.userId);
}

class GetCurrentRoutine implements UseCase<Either, GetCurrentRoutineParams> {
  final RoutineRepository repository;

  GetCurrentRoutine(this.repository);

  @override
  Future<Either<Failure, RoutineModel>> call(GetCurrentRoutineParams params) async {
    return await repository.getCurrentRoutine(params);
  }
}
