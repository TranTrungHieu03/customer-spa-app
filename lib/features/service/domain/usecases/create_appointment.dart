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
  final List<int> staffId;
  final List<int> serviceId;
  final int branchId;
  final DateTime appointmentsTime;
  final String notes;
  final int voucherId;
  final String? feedback;

  CreateAppointmentParams({
    required this.staffId,
    required this.serviceId,
    required this.branchId,
    required this.appointmentsTime,
    required this.notes,
    this.feedback,
    this.voucherId = 0,
  });

  // Phương thức toJson
  Map<String, dynamic> toJson() {
    return {
      'staffId': staffId,
      'serviceId': serviceId,
      'branchId': branchId,
      'appointmentsTime': appointmentsTime.toIso8601String(), // Chuyển DateTime thành chuỗi ISO 8601
      'notes': notes,
      'voucherId': voucherId,
      'feedback': feedback,
    };
  }

  // Phương thức copyWith
  CreateAppointmentParams copyWith({
    List<int>? staffId,
    List<int>? serviceId,
    int? branchId,
    DateTime? appointmentsTime,
    String? notes,
    int? voucherId,
    String? feedback,
  }) {
    return CreateAppointmentParams(
      staffId: staffId ?? this.staffId,
      serviceId: serviceId ?? this.serviceId,
      branchId: branchId ?? this.branchId,
      appointmentsTime: appointmentsTime ?? this.appointmentsTime,
      notes: notes ?? this.notes,
      voucherId: voucherId ?? this.voucherId,
      feedback: feedback ?? this.feedback,
    );
  }
}
