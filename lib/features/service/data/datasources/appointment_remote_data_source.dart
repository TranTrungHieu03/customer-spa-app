import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/create_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment.dart';

abstract class AppointmentRemoteDataSource {
  Future<AppointmentModel> getAppointment(GetAppointmentParams params);

  Future<AppointmentModel> createAppointment(CreateAppointmentParams params);
}

class AppointmentRemoteDataSourceImpl extends AppointmentRemoteDataSource {
  final NetworkApiService _apiService;

  AppointmentRemoteDataSourceImpl(this._apiService);

  @override
  Future<AppointmentModel> createAppointment(
      CreateAppointmentParams params) async {
    try {
      final response =
          await _apiService.postApi('/Appointment/create', params.toJson());

      print("test");
      final apiResponse = ApiResponse.fromJson(response);

      print(response);
      if (apiResponse.success) {
        return AppointmentModel.fromJson(apiResponse.result!.data!);
      } else {
        print(apiResponse.result!.message!);
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      print(e.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<AppointmentModel> getAppointment(GetAppointmentParams params) async {
    return await _apiService.getApi('/Appointments/get-by-id/${params.id}');
  }
}
