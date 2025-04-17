import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/data/model/order_appointment_model.dart';
import 'package:spa_mobile/features/service/data/model/staff_time_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/create_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment_detail.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_time_slot_by_date.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_deposit.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_full.dart';
import 'package:spa_mobile/features/service/domain/usecases/update_appointment.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, int>> createAppointment(CreateAppointmentParams params);

  Future<Either<Failure, int>> updateAppointment(UpdateAppointmentParams params);

  Future<Either<Failure, String>> payFull(PayFullParams params);

  Future<Either<Failure, String>> payDeposit(PayDepositParams params);

  Future<Either<Failure, List<AppointmentModel>>> getHistoryBooking(GetListAppointmentParams params);

  Future<Either<Failure, OrderAppointmentModel>> getAppointment(GetAppointmentParams params);

  Future<Either<Failure, AppointmentModel>> getAppointmentDetail(GetAppointmentDetailParams params);

  Future<Either<Failure, List<StaffTimeModel>>> getTimeSlots(GetTimeSlotByDateParams params);
}
