import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/domain/repository/appointment_repository.dart';

class CreateAppointment implements UseCase<Either, CreateAppointmentParams> {
  final AppointmentRepository _appointmentRepository;

  CreateAppointment(this._appointmentRepository);

  @override
  Future<Either<Failure, List<AppointmentModel>>> call(CreateAppointmentParams params) async {
    return await _appointmentRepository.createAppointment(params);
  }
}

class CreateAppointmentParams {
  final int customerId;
  final List<int> staffId;
  final List<int> serviceId;
  final int branchId;
  final DateTime appointmentsTime;
  final String notes;

  CreateAppointmentParams({
    required this.customerId,
    required this.staffId,
    required this.serviceId,
    required this.branchId,
    required this.appointmentsTime,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'customerId': customerId,
      'staffId': staffId,
      'serviceId': serviceId,
      'branchId': branchId,
      'appointmentsTime': appointmentsTime.toIso8601String(),
      'notes': notes,
      'status': "",
      'feedback': ""
    };
  }
}
