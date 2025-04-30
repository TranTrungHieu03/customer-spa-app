import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  final UserModel? customer;

  final StaffModel? staff;
  final BranchModel? branch;
  final ServiceModel service;

  const AppointmentModel({
    required super.customerId,
    required super.appointmentId,
    required super.staffId,
    required super.serviceId,
    required super.branchId,
    required super.appointmentsTime,
    required super.status,
    required super.notes,
    required super.feedback,
    this.customer,
    this.staff,
    this.branch,
    super.step,
    required this.service,
    required super.quantity,
    required super.unitPrice,
    required super.subTotal,
    required super.appointmentEndTime,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    AppLogger.debug(json);
    return AppointmentModel(
        appointmentId: json['appointmentId'],
        customerId: json['customerId'],
        staffId: json['staffId'],
        serviceId: json['serviceId'],
        branchId: json['branchId'],
        appointmentsTime: DateTime.parse(json['appointmentsTime']),
        status: json['status'],
        notes: json['notes'],
        feedback: json['feedback'],
        customer: json['customer'] != null ? UserModel.fromJson(json['customer']) : null,
        staff: json['staff'] != null ? StaffModel.fromJson(json['staff']) : null,
        branch: json['branch'] != null ? BranchModel.fromJson(json['branch']) : null,
        service: ServiceModel.fromJson(json['service']),
        quantity: json['quantity'] ?? 0,
        unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
        subTotal: (json['subTotal'] as num?)?.toDouble() ?? 0.0,
        appointmentEndTime: DateTime.parse(json['appointmentEndTime'] ?? '${DateTime.now()}'),
        step: json['step'] ?? 0);
  }

  factory AppointmentModel.empty() {
    final now = DateTime.now();
    return AppointmentModel(
      appointmentId: 0,
      customerId: 0,
      staffId: 0,
      serviceId: 0,
      branchId: 0,
      appointmentsTime: now,
      status: '',
      notes: '',
      feedback: '',
      customer: null,
      staff: null,
      branch: null,
      service: ServiceModel.empty(),
      // giả sử ServiceModel cũng có ServiceModel.empty()
      quantity: 0,
      unitPrice: 0.0,
      subTotal: 0.0,
      appointmentEndTime: now,
    );
  }

// Appointment copyWith({
//   int? customerId,
//   int? appointmentId,
//   int? staffId,
//   int? serviceId,
//   int? branchId,
//   DateTime? appointmentsTime,
//   String? status,
//   String? notes,
//   String? feedback,
//   UserModel? customer,
//   UserModel? staff,
//   BranchModel? branch,
//   ServiceModel? service,
// }) {
//   return AppointmentModel(
//     appointmentId: appointmentId ?? this.appointmentId,
//     customerId: customerId ?? this.customerId,
//     staffId: staffId ?? staffId,
//     serviceId: serviceId ?? this.serviceId,
//     branchId: branchId ?? this.branchId,
//     appointmentsTime: appointmentsTime ?? this.appointmentsTime,
//     status: status ?? this.status,
//     notes: notes ?? this.notes,
//     feedback: feedback ?? this.feedback,
//     customer: customer ?? this.customer,
//     // staff: staff ?? this.staff,
//     branch: branch ?? this.branch,
//     service: service ?? this.service,
//   );
// }
}
