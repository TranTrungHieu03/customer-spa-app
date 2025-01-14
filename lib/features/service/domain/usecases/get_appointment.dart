import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/domain/repository/appointment_repository.dart';

class GetAppointment implements UseCase<Either, GetAppointmentParams> {
  final AppointmentRepository _appointmentRepository;

  GetAppointment(this._appointmentRepository);

  @override
  Future<Either<Failure, AppointmentModel>> call(GetAppointmentParams params) async {
    return await _appointmentRepository.getAppointment(params);
  }
}

class GetAppointmentParams {
  final int id;

  GetAppointmentParams({required this.id});
}
