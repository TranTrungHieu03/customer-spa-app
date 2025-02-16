import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/analysis_response_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/skin_analysis_via_form.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/skin_analysis_via_image.dart';

abstract class SkinAnalysisRepository {
  Future<Either<Failure, AnalysisResponseModel>> analysisViaImage(SkinAnalysisViaImageParams params);
  Future<Either<Failure, AnalysisResponseModel>> analysisViaForm(SkinAnalysisViaFormParams params);
}
