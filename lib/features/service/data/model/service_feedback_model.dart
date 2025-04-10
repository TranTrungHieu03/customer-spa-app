import 'package:spa_mobile/features/home/domain/entities/feedback.dart';

class ServiceFeedbackModel extends Feedback {
  final int serviceFeedbackId;

  ServiceFeedbackModel(
      {required super.customerId,
      required super.status,
      super.comment,
      super.rating,
      required this.serviceFeedbackId,
      required super.createdAt,
      required super.updatedAt});

  factory ServiceFeedbackModel.fromJson(Map<String, dynamic> json) {
    return ServiceFeedbackModel(
      customerId: json['customerId'],
      status: json['status'],
      comment: json['comment'],
      rating: json['rating'],
      serviceFeedbackId: json['serviceFeedbackId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
