import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/domain/usecases/create_appointment.dart';
import 'package:spa_mobile/features/service/domain/usecases/get_appointment.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, AppointmentModel>> createAppointment(CreateAppointmentParams params);

  Future<Either<Failure, AppointmentModel>> getAppointment(GetAppointmentParams params);
}
