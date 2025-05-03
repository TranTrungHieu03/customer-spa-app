import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/domain/repository/appointment_repository.dart';

class CreateAppointment implements UseCase<Either, CreateAppointmentParams> {
  final AppointmentRepository _appointmentRepository;

  CreateAppointment(this._appointmentRepository);

  @override
  Future<Either<Failure, int>> call(CreateAppointmentParams params) async {
    return await _appointmentRepository.createAppointment(params);
  }
}

class CreateAppointmentParams {
  final List<int> staffId;
  final List<int> serviceId;
  final int branchId;
  final List<DateTime> appointmentsTime;
  final String notes;
  final int voucherId;
  final String? feedback;
  final int totalMinutes;
  final int userId;
  final String paymentMethod;

  CreateAppointmentParams({
    required this.userId,
    required this.staffId,
    required this.serviceId,
    required this.branchId,
    required this.appointmentsTime,
    required this.notes,
    required this.paymentMethod,
    this.feedback,
    this.voucherId = 0,
    this.totalMinutes = 0,
  });

  // Phương thức toJson
  Map<String, dynamic> toJson() {
    return {
      'staffId': staffId,
      'serviceId': serviceId,
      'branchId': branchId,
      'appointmentsTime': appointmentsTime.map((e) => e.toIso8601String()).toList(),
      'notes': notes,
      'voucherId': voucherId,
      'feedback': feedback,
      'totalMinutes': totalMinutes,
      'userId': userId,
      'paymentMedhod': paymentMethod
    };
  }

  // Phương thức copyWith
  CreateAppointmentParams copyWith(
      {List<int>? staffId,
      List<int>? serviceId,
      int? branchId,
      List<DateTime>? appointmentsTime,
      String? notes,
      int? voucherId,
      String? feedback,
      int? totalMinutes,
      String? paymentMethod,
      int? userId}) {
    return CreateAppointmentParams(
        staffId: staffId ?? this.staffId,
        serviceId: serviceId ?? this.serviceId,
        branchId: branchId ?? this.branchId,
        appointmentsTime: appointmentsTime ?? this.appointmentsTime,
        notes: notes ?? this.notes,
        voucherId: voucherId ?? this.voucherId,
        feedback: feedback ?? this.feedback,
        totalMinutes: totalMinutes ?? this.totalMinutes,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        userId: userId ?? this.userId);
  }
}
