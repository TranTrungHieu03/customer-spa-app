import 'package:spa_mobile/features/service/domain/entities/appointment_feedback.dart';

class AppointmentFeedbackModel extends AppointmentFeedback {
  const AppointmentFeedbackModel({
    required super.id,
    required super.customerId,
    required super.staffId,
    required super.appointmentId,
    required super.imageBefore,
    required super.imageAfter,
    required super.note,
  });

  factory AppointmentFeedbackModel.fromJson(Map<String, dynamic> json) {
    return AppointmentFeedbackModel(
      id: json['appointmentFeedbackId'] as int,
      customerId: json['customerId'] as int,
      staffId: json['staffId'] ?? 0 as int,
      appointmentId: json['appointmentId'] as int,
      imageBefore: json['imageBefore'],
      imageAfter: json['imageAfter'],
      note: json['comment'],
    );
  }

  factory AppointmentFeedbackModel.isEmpty() {
    return const AppointmentFeedbackModel(
      id: 0,
      customerId: 0,
      staffId: 0,
      appointmentId: 0,
      imageBefore: '',
      imageAfter: '',
      note: '',
    );
  }
}
