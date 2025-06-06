import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/list_order_routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/order_routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_logger_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_step_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_tracking_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/book_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/feedback_step.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_current_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_feedback_steps.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_history_order_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_list_appointment_by_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_order_routine.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_detail.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_history.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_step.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/get_routine_tracking.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/order_mix.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/update_appointment_routine.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';

abstract class RoutineRemoteDataSource {
  Future<List<RoutineModel>> getListSkinCare();

  Future<RoutineModel> getRoutineDetail(GetRoutineDetailParams params);

  Future<List<RoutineStepModel>> getRoutineStep(GetRoutineStepParams params);

  Future<List<RoutineModel>> getHistoryRoutine(GetRoutineHistoryParams params);

  Future<int> bookRoutine(BookRoutineParams params);

  Future<OrderRoutineModel> getOrderRoutine(GetOrderRoutineParams params);

  Future<ListOrderRoutineModel> getHistoryOrderRoutine(GetHistoryOrderRoutineParams params);

  Future<RoutineModel> getCurrentRoutine(GetCurrentRoutineParams params);

  Future<RoutineTrackingModel> getRoutineTracking(GetRoutineTrackingParams params);

  Future<List<AppointmentModel>> getAppointmentsByRoutine(GetListAppointmentByRoutineParams params);

  Future<int> orderMix(OrderMixParams params);

  Future<String> updateAppointmentRoutine(UpdateAppointmentRoutineParams params);

  Future<String> feedbackStep(FeedbackStepParams params);

  Future<List<RoutineLoggerModel>> getFeedbackStepByRoutineId(GetFeedbackStepParams params);
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
        return (apiResponse.result!.data as List).map((x) => RoutineStepModel.fromJson(x, null, "")).toList();
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
      final response = await _apiService.getApi('/Routine/tracking-user-routine/${params.userRoutineId}');

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

  @override
  Future<List<RoutineModel>> getHistoryRoutine(GetRoutineHistoryParams params) async {
    try {
      final response = await _apiService.getApi('/Routine/get-list-routine-by/${params.userId}/${params.status}');

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
  Future<OrderRoutineModel> getOrderRoutine(GetOrderRoutineParams params) async {
    try {
      final response = await _apiService.getApi('/Order/detail-booking?orderId=${params.orderId}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return OrderRoutineModel.fromJson(apiResponse.result!.data);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<ListOrderRoutineModel> getHistoryOrderRoutine(GetHistoryOrderRoutineParams params) async {
    try {
      final response = await _apiService.getApi('/Order/history-booking?page=${params.page}&status=${params.status}&orderType=routine');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return ListOrderRoutineModel.fromJson(apiResponse.result!.data, apiResponse.result!.pagination);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<AppointmentModel>> getAppointmentsByRoutine(GetListAppointmentByRoutineParams params) async {
    try {
      final response = await _apiService.getApi('/Appointments/get-appointments-by-routine?routineId=${params.id}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.data as List).map((x) => AppointmentModel.fromJson(x)).toList();
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<int> orderMix(OrderMixParams params) async {
    try {
      AppLogger.debug(params.toJson());
      final response = await _apiService.postApi('/Order/create-order-with-products-and-services', params.toJson());

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
  Future<String> updateAppointmentRoutine(UpdateAppointmentRoutineParams params) async {
    try {
      final response = await _apiService.patchApi('/Routine/update-start-time-of-routine', params.toJson());

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.message!);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> feedbackStep(FeedbackStepParams params) async {
    try {
      final response = await _apiService.postApi('/UserRoutineLogger/create', params.toJson());

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.message!);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<RoutineLoggerModel>> getFeedbackStepByRoutineId(GetFeedbackStepParams params) async {
    try {
      final response =
          await _apiService.getApi('/UserRoutineLogger/get-all?userRoutineId=${params.userRoutineId}&pageIndex=1&pageSize=100');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.data as List).map((e) => RoutineLoggerModel.fromJson(e)).toList();
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
