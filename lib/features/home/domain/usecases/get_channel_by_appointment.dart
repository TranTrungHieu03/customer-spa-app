import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/domain/repositories/hub_repository.dart';

class GetChannelByAppointmentParams {
  final String appointmentId;

  const GetChannelByAppointmentParams(
    this.appointmentId,
  );
}

class GetChannelByAppointment implements UseCase<Either, GetChannelByAppointmentParams> {
  final HubRepository _repository;

  GetChannelByAppointment(this._repository);

  @override
  Future<Either> call(GetChannelByAppointmentParams params) async {
    return await _repository.getChannelByAppointmentId(params);
  }
}
