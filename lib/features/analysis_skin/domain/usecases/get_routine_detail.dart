import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/analysis_response_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_health_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/skin_analysis_repository.dart';

class GetRoutineDetail implements UseCase<Either, GetRoutineDetailParams> {
  final SkinAnalysisRepository _skinAnalysisRepository;

  GetRoutineDetail(this._skinAnalysisRepository);

  @override
  Future<Either<Failure, RoutineModel>> call(GetRoutineDetailParams params) async {
    return await _skinAnalysisRepository.getRoutineDetail(params);
  }
}

class GetRoutineDetailParams {
  final String id;

  GetRoutineDetailParams(this.id);

  Map<String, dynamic> toJson() {
    return {'id': this.id};
  }
}
