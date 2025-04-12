import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/home/domain/entities/feedback.dart';

class ServiceFeedbackModel extends Feedback {
  final int serviceFeedbackId;
  final UserModel? customer;

  ServiceFeedbackModel(
      {required super.customerId,
      required super.status,
      super.comment,
      super.rating,
      required this.serviceFeedbackId,
      required super.createdAt,
      this.customer,
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
      customer: json['customer'] != null ? UserModel.fromJson(json['customer']) : null,
    );
  }
}
