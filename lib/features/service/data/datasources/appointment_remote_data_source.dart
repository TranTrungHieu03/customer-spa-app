import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/create_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_appointment.dart';

abstract class AppointmentRemoteDataSource {
  Future<AppointmentModel> getAppointment(GetAppointmentParams params);

  Future<List<AppointmentModel>> createAppointment(CreateAppointmentParams params);

  Future<List<AppointmentModel>> getHistoryBooking(GetListAppointmentParams params);
}

class AppointmentRemoteDataSourceImpl extends AppointmentRemoteDataSource {
  final NetworkApiService _apiService;

  AppointmentRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<AppointmentModel>> createAppointment(CreateAppointmentParams params) async {
    try {
      final response = await _apiService.postApi('/Appointments/create', params.toJson());

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.data as List).map((e) => AppointmentModel.fromJson(e)).toList();
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      AppLogger.info(e.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<AppointmentModel> getAppointment(GetAppointmentParams params) async {
    try {
      final response = await _apiService.getApi('/Appointments/get-by-id/${params.id}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return AppointmentModel.fromJson(apiResponse.result!.data!);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      AppLogger.info(e.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<AppointmentModel>> getHistoryBooking(GetListAppointmentParams params) async {
    try {
      final response = await _apiService.getApi('/Appointments/history-booking?page=${params.page}&status=${params.status}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.data as List).map((e) => AppointmentModel.fromJson(e)).toList();
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      AppLogger.info(e.toString());
      throw AppException(e.toString());
    }
  }
}
