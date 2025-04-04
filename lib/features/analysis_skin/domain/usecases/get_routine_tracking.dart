import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_tracking_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/routine_repository.dart';

class GetRoutineTrackingParams {
  final int userId;
  final int routineId;

  GetRoutineTrackingParams({
    required this.userId,
    required this.routineId,
  });
}

class GetRoutineTracking implements UseCase<Either, GetRoutineTrackingParams> {
  final RoutineRepository repository;

  GetRoutineTracking(this.repository);

  @override
  Future<Either<Failure, RoutineTrackingModel>> call(GetRoutineTrackingParams params) async {
    return await repository.getRoutineTracking(params);
  }
}
