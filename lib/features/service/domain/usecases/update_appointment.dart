import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/domain/repository/appointment_repository.dart';

class UpdateAppointmentParams {
  final int appointmentId;
  final int customerId;
  final int staffId;
  final int serviceId;
  final int branchId;
  final DateTime appointmentsTime;
  final String notes;

  UpdateAppointmentParams({
    required this.customerId,
    required this.staffId,
    required this.serviceId,
    required this.branchId,
    required this.appointmentsTime,
    required this.notes,
    required this.appointmentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'staffId': staffId,
      'serviceId': serviceId,
      'branchId': branchId,
      'appointmentsTime': appointmentsTime.toIso8601String(),
      'notes': notes,
      'feedback': "",
      "status": "Pending",
      "statusPayment": ""
    };
  }
}

class UpdateAppointment implements UseCase<Either, UpdateAppointmentParams> {
  final AppointmentRepository repository;

  UpdateAppointment(this.repository);

  @override
  Future<Either<Failure, int>> call(UpdateAppointmentParams params) async {
    return await repository.updateAppointment(params);
  }
}
