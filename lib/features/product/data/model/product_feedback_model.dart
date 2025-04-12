import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/home/domain/entities/feedback.dart';

class ProductFeedbackModel extends Feedback {
  final int productFeedbackId;
  final UserModel? customer;

  ProductFeedbackModel(
      {required super.customerId,
      required super.status,
      super.comment,
      super.rating,
      required this.productFeedbackId,
      required super.createdAt,
      required super.updatedAt,
      this.customer});

  factory ProductFeedbackModel.fromJson(Map<String, dynamic> json) {
    return ProductFeedbackModel(
        customerId: json['customerId'],
        status: json['status'],
        comment: json['comment'],
        rating: json['rating'],
        productFeedbackId: json['productFeedbackId'],
        customer: json['customer'] != null ? UserModel.fromJson(json['customer']) : null,
        createdAt: json['createdDate'],
        updatedAt: json['updatedDate']);
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'status': status,
      'comment': comment,
      'rating': rating,
      'productFeedbackId': productFeedbackId,
    };
  }
}
