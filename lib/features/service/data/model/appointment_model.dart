import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  final UserModel? customer;
  final UserModel? staff;
  final BranchModel branch;
  final ServiceModel service;

  const AppointmentModel({
    required super.customerId,
    required super.staffId,
    required super.serviceId,
    required super.branchId,
    required super.appointmentsTime,
    required super.status,
    required super.notes,
    required super.feedback,
    this.customer,
    this.staff,
    required this.branch,
    required this.service,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      customerId: json['customerId'],
      staffId: json['staffId'],
      serviceId: json['serviceId'],
      branchId: json['branchId'],
      appointmentsTime: DateTime.parse(json['appointmentsTime']),
      status: json['status'],
      notes: json['notes'],
      feedback: json['feedback'],
      customer: json['customer'] != null
          ? UserModel.fromJson(json['customer'])
          : null,
      staff: json['staff'] != null ? UserModel.fromJson(json['staff']) : null,
      branch: BranchModel.fromJson(json['branch']),
      service: ServiceModel.fromJson(json['service']),
    );
  }

  Appointment copyWith({
    int? customerId,
    int? staffId,
    int? serviceId,
    int? branchId,
    DateTime? appointmentsTime,
    String? status,
    String? notes,
    String? feedback,
    UserModel? customer,
    UserModel? staff,
    BranchModel? branch,
    ServiceModel? service,
  }) {
    return AppointmentModel(
      customerId: customerId ?? this.customerId,
      staffId: staffId ?? this.staffId,
      serviceId: serviceId ?? this.serviceId,
      branchId: branchId ?? this.branchId,
      appointmentsTime: appointmentsTime ?? this.appointmentsTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      feedback: feedback ?? this.feedback,
      customer: customer ?? this.customer,
      staff: staff ?? this.staff,
      branch: branch ?? this.branch,
      service: service ?? this.service,
    );
  }
}
