import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/analysis_response_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_detail.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/skin_analysis_via_form.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/skin_analysis_via_image.dart';

abstract class SkinAnalysisRemoteDataSource {
  Future<AnalysisResponseModel> skinAnalysisViaImage(SkinAnalysisViaImageParams params);

  Future<AnalysisResponseModel> skinAnalysisViaForm(SkinAnalysisViaFormParams params);

  Future<RoutineModel> getRoutineDetail(GetRoutineDetailParams params);
}

class SkinAnalysisRemoteDataSourceImpl implements SkinAnalysisRemoteDataSource {
  final NetworkApiService _apiService;

  SkinAnalysisRemoteDataSourceImpl(this._apiService);

  @override
  Future<AnalysisResponseModel> skinAnalysisViaImage(SkinAnalysisViaImageParams params) async {
    try {
      final formData = await params.toFormData();
      final response = await _apiService.postApi('/SkinAnalyze/analyze', formData);

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return AnalysisResponseModel.fromJson(apiResponse.result!.data);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<AnalysisResponseModel> skinAnalysisViaForm(SkinAnalysisViaFormParams params) async {
    try {
      AppLogger.debug(params.toJson());
      final response = await _apiService.postApi('/SkinAnalyze/analyze_form', params.toJson());

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return AnalysisResponseModel.fromJson(apiResponse.result!.data);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<RoutineModel> getRoutineDetail(GetRoutineDetailParams params) async {
    try {
      final response = await _apiService.getApi('/Routine/${params.id}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return RoutineModel.fromJson(apiResponse.result!.data);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
