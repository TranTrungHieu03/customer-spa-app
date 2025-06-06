import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final int customerId;
  final int appointmentId;
  final int staffId;
  final int serviceId;
  final int branchId;
  final DateTime appointmentsTime;
  final DateTime appointmentEndTime;
  final String status;
  final String notes;
  final String feedback;
  final int quantity;
  final double unitPrice;
  final double subTotal;
  final int? step;

  const Appointment({
    required this.appointmentId,
    required this.customerId,
    required this.staffId,
    required this.serviceId,
    required this.branchId,
    required this.appointmentsTime,
    required this.appointmentEndTime,
    required this.status,
    required this.notes,
    required this.feedback,
    required this.quantity,
    required this.unitPrice,
    required this.subTotal,
    this.step
  });

  @override
  List<Object?> get props => [appointmentId];
}
