import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/analysis_response_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/skin_analysis_via_image.dart';

abstract class SkinAnalysisRemoteDataSource {
  Future<AnalysisResponseModel> skinAnalysisViaImage(SkinAnalysisViaImageParams params);
}

class SkinAnalysisRemoteDataSourceImpl implements SkinAnalysisRemoteDataSource {
  final NetworkApiService _apiService;

  SkinAnalysisRemoteDataSourceImpl(this._apiService);

  @override
  Future<AnalysisResponseModel> skinAnalysisViaImage(SkinAnalysisViaImageParams params) async {
    try {
      final response = await _apiService.postApi('/SkinAnalyze/analyze', await params.toFormData());

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
}
