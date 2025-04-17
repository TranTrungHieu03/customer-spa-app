import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/service/data/datasources/appointment_remote_data_source.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/data/model/order_appointment_model.dart';
import 'package:spa_mobile/features/service/data/model/staff_time_model.dart';
import 'package:spa_mobile/features/service/domain/repository/appointment_repository.dart';
import 'package:spa_mobile/features/service/domain/usecases/create_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment_detail.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_time_slot_by_date.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_deposit.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_full.dart';
import 'package:spa_mobile/features/service/domain/usecases/update_appointment.dart';

class AppointmentRepositoryImpl extends AppointmentRepository {
  final AppointmentRemoteDataSource _appointmentRemoteDataSource;

  AppointmentRepositoryImpl(this._appointmentRemoteDataSource);

  @override
  Future<Either<Failure, int>> createAppointment(CreateAppointmentParams params) async {
    try {
      int response = await _appointmentRemoteDataSource.createAppointment(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderAppointmentModel>> getAppointment(GetAppointmentParams params) async {
    try {
      OrderAppointmentModel response = await _appointmentRemoteDataSource.getAppointment(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentModel>>> getHistoryBooking(GetListAppointmentParams params) async {
    try {
      List<AppointmentModel> response = await _appointmentRemoteDataSource.getHistoryBooking(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StaffTimeModel>>> getTimeSlots(GetTimeSlotByDateParams params) async {
    try {
      List<StaffTimeModel> response = await _appointmentRemoteDataSource.getTimeSlots(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> payFull(PayFullParams params) async {
    try {
      String response = await _appointmentRemoteDataSource.payFull(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> payDeposit(PayDepositParams params) async {
    try {
      String response = await _appointmentRemoteDataSource.payDeposit(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentModel>> getAppointmentDetail(GetAppointmentDetailParams params) async {
    try {
      AppointmentModel response = await _appointmentRemoteDataSource.getAppointmentDetail(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> updateAppointment(UpdateAppointmentParams params) async {
    try {
      int response = await _appointmentRemoteDataSource.updateAppointment(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }
}
