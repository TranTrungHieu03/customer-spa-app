import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_step_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_tracking_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/book_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_current_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_detail.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_step.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_tracking.dart';

abstract class RoutineRemoteDataSource {
  Future<List<RoutineModel>> getListSkinCare();

  Future<RoutineModel> getRoutineDetail(GetRoutineDetailParams params);

  Future<List<RoutineStepModel>> getRoutineStep(GetRoutineStepParams params);

  Future<int> bookRoutine(BookRoutineParams params);

  Future<RoutineModel> getCurrentRoutine(GetCurrentRoutineParams params);

  Future<RoutineTrackingModel> getRoutineTracking(GetRoutineTrackingParams params);
}

class RoutineRemoteDateSourceImpl implements RoutineRemoteDataSource {
  final NetworkApiService _apiService;

  RoutineRemoteDateSourceImpl(this._apiService);

  @override
  Future<List<RoutineModel>> getListSkinCare() async {
    try {
      final response = await _apiService.getApi('/Routine/get-list-skincare-routines');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.data as List).map((x) => RoutineModel.fromJson(x)).toList();
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

  @override
  Future<List<RoutineStepModel>> getRoutineStep(GetRoutineStepParams params) async {
    try {
      final response = await _apiService.getApi('/Routine/get-list-skincare-routines-step/${params.id}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.data as List).map((x) => RoutineStepModel.fromJson(x)).toList();
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<int> bookRoutine(BookRoutineParams params) async {
    try {
      final response = await _apiService.postApi('/Routine/book-compo-skin-care-routine', params.toJson());

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.data);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<RoutineModel> getCurrentRoutine(GetCurrentRoutineParams params) async {
    try {
      final response = await _apiService.getApi('/Routine/get-routine-of-user-newest/${params.userId}');

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

  @override
  Future<RoutineTrackingModel> getRoutineTracking(GetRoutineTrackingParams params) async {
    try {
      final response = await _apiService.getApi('/Routine/tracking-user-routine/${params.routineId}/${params.userId}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return RoutineTrackingModel.fromJson(apiResponse.result!.data);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
