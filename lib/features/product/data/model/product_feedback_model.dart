import 'package:spa_mobile/features/home/domain/entities/feedback.dart';

class ProductFeedbackModel extends Feedback {
  final int productFeedbackId;

  ProductFeedbackModel({
    required super.customerId,
    required super.status,
    super.comment,
    super.rating,
    required this.productFeedbackId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductFeedbackModel.fromJson(Map<String, dynamic> json) {
    return ProductFeedbackModel(
        customerId: json['customerId'],
        status: json['status'],
        comment: json['comment'],
        rating: json['rating'],
        productFeedbackId: json['productFeedbackId'],
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
