import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/service/data/datasources/appointment_remote_data_source.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/domain/repository/appointment_repository.dart';
import 'package:spa_mobile/features/service/domain/usecases/create_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment.dart';

class AppointmentRepositoryImpl extends AppointmentRepository {
  final AppointmentRemoteDataSource _appointmentRemoteDataSource;

  AppointmentRepositoryImpl(this._appointmentRemoteDataSource);

  @override
  Future<Either<Failure, AppointmentModel>> createAppointment(CreateAppointmentParams params) async {
    try {
      AppointmentModel response = await _appointmentRemoteDataSource.createAppointment(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> getAppointment(GetAppointmentParams params) async {
    try {
      AppointmentModel response = await _appointmentRemoteDataSource.getAppointment(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }
}
