import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/routine_repository.dart';

class GetListRoutine implements UseCase<Either, NoParams> {
  final RoutineRepository routineRepository;

  GetListRoutine(this.routineRepository);

  @override
  Future<Either<Failure, List<RoutineModel>>> call(NoParams params) async {
    return await routineRepository.getListSkinCareRoutine();
  }
}
