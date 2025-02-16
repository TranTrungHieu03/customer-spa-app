import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/analysis_response_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_health_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/skin_analysis_repository.dart';

class SkinAnalysisViaForm implements UseCase<Either, SkinAnalysisViaFormParams> {
  final SkinAnalysisRepository _skinAnalysisRepository;

  SkinAnalysisViaForm(this._skinAnalysisRepository);

  @override
  Future<Either<Failure, AnalysisResponseModel>> call(SkinAnalysisViaFormParams params) async {
    return await _skinAnalysisRepository.analysisViaForm(params);
  }
}

class SkinAnalysisViaFormParams {
  final SkinHealthModel model;

  SkinAnalysisViaFormParams(this.model);

  Map<String, dynamic> toJson() {
    return model.toJson();
  }
}
