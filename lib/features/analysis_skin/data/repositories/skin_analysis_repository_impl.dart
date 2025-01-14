import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/analysis_skin/data/datasources/skin_analysis_remote_data_source.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/analysis_response_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/skin_analysis_repository.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/skin_analysis_via_image.dart';

class SkinAnalysisRepositoryImpl implements SkinAnalysisRepository {
  final SkinAnalysisRemoteDataSource _analysisRemoteDataSource;

  SkinAnalysisRepositoryImpl(this._analysisRemoteDataSource);

  @override
  Future<Either<Failure, AnalysisResponseModel>> analysisViaImage(SkinAnalysisViaImageParams params) async {
    try {
      AnalysisResponseModel result = await _analysisRemoteDataSource.skinAnalysisViaImage(params);
      return right(result);
    } catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }
}
