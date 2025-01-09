import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/analysis_response_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/repositories/skin_analysis_repository_impl.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/skin_analysis_repository.dart';

class SkinAnalysisViaImage
    implements UseCase<Either, SkinAnalysisViaImageParams> {
  final SkinAnalysisRepository _skinAnalysisRepository;

  SkinAnalysisViaImage(this._skinAnalysisRepository);

  @override
  Future<Either<Failure, AnalysisResponseModel>> call(
      SkinAnalysisViaImageParams params) async {
    return await _skinAnalysisRepository.analysisViaImage(params);
  }
}

class SkinAnalysisViaImageParams {
  final String path;

  SkinAnalysisViaImageParams(this.path);

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "file": await MultipartFile.fromFile(path),
    });
  }
}
