import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/domain/repository/appointment_repository.dart';

class CancelAppointmentDetailParams {
  final String appointmentId;

  CancelAppointmentDetailParams(this.appointmentId);
}

class CancelAppointmentDetail implements UseCase<Either, CancelAppointmentDetailParams> {
  final AppointmentRepository repository;

  CancelAppointmentDetail(this.repository);

  @override
  Future<Either<Failure, String>> call(CancelAppointmentDetailParams params) async {
    return await repository.cancelAppointmentDetail(params);
  }
}
