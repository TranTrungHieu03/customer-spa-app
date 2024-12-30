import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final int customerId;
  final int staffId;
  final int serviceId;
  final int branchId;
  final DateTime appointmentsTime;
  final String status;
  final String notes;
  final String feedback;

  const Appointment({
    required this.customerId,
    required this.staffId,
    required this.serviceId,
    required this.branchId,
    required this.appointmentsTime,
    required this.status,
    required this.notes,
    required this.feedback,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
