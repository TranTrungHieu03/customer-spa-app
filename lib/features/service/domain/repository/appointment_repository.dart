import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/service/data/model/list_order_model.dart';
import 'package:spa_mobile/features/service/data/model/order_appointment_model.dart';
import 'package:spa_mobile/features/service/data/model/time_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/create_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_list_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_time_slot_by_date.dart';
import 'package:spa_mobile/features/service/domain/usecases/pay_full.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, int>> createAppointment(CreateAppointmentParams params);

  Future<Either<Failure, String>> payFull(PayFullParams params);

  // Future<Either<Failure, String>> payDeposit(CreateAppointmentParams params);

  Future<Either<Failure, ListOrderAppointmentModel>> getHistoryBooking(GetListAppointmentParams params);

  Future<Either<Failure, OrderAppointmentModel>> getAppointment(GetAppointmentParams params);

  Future<Either<Failure, List<TimeModel>>> getTimeSlots(GetTimeSlotByDateParams params);
}
