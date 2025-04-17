import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/domain/repository/appointment_repository.dart';

class GetAppointmentDetailParams {
  final String appointmentId;

  const GetAppointmentDetailParams({
    required this.appointmentId,
  });
}

class GetAppointmentDetail implements UseCase<Either, GetAppointmentDetailParams> {
  final AppointmentRepository repository;

  const GetAppointmentDetail(this.repository);

  @override
  Future<Either> call(GetAppointmentDetailParams params) async {
    return await repository.getAppointmentDetail(params);
  }
}
