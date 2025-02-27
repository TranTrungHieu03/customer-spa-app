import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/analysis_response_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/repositories/skin_analysis_repository.dart';

class SkinAnalysisViaImage implements UseCase<Either, SkinAnalysisViaImageParams> {
  final SkinAnalysisRepository _skinAnalysisRepository;

  SkinAnalysisViaImage(this._skinAnalysisRepository);

  @override
  Future<Either<Failure, AnalysisResponseModel>> call(SkinAnalysisViaImageParams params) async {
    return await _skinAnalysisRepository.analysisViaImage(params);
  }
}

class SkinAnalysisViaImageParams {
  final File path;

  SkinAnalysisViaImageParams(this.path);

  Future<FormData> toFormData() async {
    AppLogger.info("Path: ${path.path}");
    return FormData.fromMap({
      "file": MultipartFile.fromFileSync(
        path.path,
        filename: path.path.split('/').last,
        contentType: DioMediaType("image", "jpeg"),
      ),
    });
  }
}
