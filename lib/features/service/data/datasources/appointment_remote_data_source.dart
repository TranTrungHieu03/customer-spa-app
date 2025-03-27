import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/service/data/model/list_order_model.dart';
import 'package:spa_mobile/features/service/data/model/order_appointment_model.dart';
import 'package:spa_mobile/features/service/data/model/time_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/create_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_time_slot_by_date.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_deposit.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_full.dart';

abstract class AppointmentRemoteDataSource {
  Future<OrderAppointmentModel> getAppointment(GetAppointmentParams params);

  Future<int> createAppointment(CreateAppointmentParams params);

  Future<String> payFull(PayFullParams params);

  Future<String> payDeposit(PayDepositParams params);

  Future<ListOrderAppointmentModel> getHistoryBooking(GetListAppointmentParams params);

  Future<List<TimeModel>> getTimeSlots(GetTimeSlotByDateParams params);
}

class AppointmentRemoteDataSourceImpl extends AppointmentRemoteDataSource {
  final NetworkApiService _apiService;

  AppointmentRemoteDataSourceImpl(this._apiService);

  @override
  Future<int> createAppointment(CreateAppointmentParams params) async {
    try {
      final response = await _apiService.postApi('/Appointments/create', params.toJson());

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return apiResponse.result!.data;
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      AppLogger.info(e.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<OrderAppointmentModel> getAppointment(GetAppointmentParams params) async {
    try {
      final response = await _apiService.getApi('/Order/detail-booking?orderId=${params.id}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        AppLogger.info(apiResponse.result!.data!);
        return OrderAppointmentModel.fromJson(apiResponse.result!.data!);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      AppLogger.info(e.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<ListOrderAppointmentModel> getHistoryBooking(GetListAppointmentParams params) async {
    try {
      final response = await _apiService.getApi('/Order/history-booking?page=${params.page}&status=${params.status}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return ListOrderAppointmentModel.fromJson(apiResponse.result!.data, apiResponse.result!.pagination);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      AppLogger.info(e.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<TimeModel>> getTimeSlots(GetTimeSlotByDateParams params) async {
    try {
      final response = await _apiService.getApi('/Staff/staff-busy-times?staffId=${params.staffId}&date=${params.date.toString()}');
      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        if (apiResponse.result!.data == null) {
          return [];
        }
        AppLogger.info(apiResponse.result!.data);
        return (apiResponse.result!.data as List).map((x) => TimeModel.fromJson(x)).toList();
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      AppLogger.info(e.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> payFull(PayFullParams params) async {
    try {
      final response = await _apiService.postApi('/Order/confirm-order-appointment', params.toJson());

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return apiResponse.result!.data;
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      AppLogger.info(e.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> payDeposit(PayDepositParams params) async {
    try {
      final response = await _apiService.postApi('/Order/confirm-order-deposit', params.toJson());

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return apiResponse.result!.data;
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      AppLogger.info(e.toString());
      throw AppException(e.toString());
    }
  }
}
