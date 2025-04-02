import 'package:spa_mobile/features/product/domain/entities/promotion.dart';

class PromotionModel extends Promotion {
  const PromotionModel(
      {required super.promotionId,
      required super.promotionName,
      required super.promotionDescription,
      required super.discountPercent,
      required super.startDate,
      required super.endDate,
      required super.status,
      required super.image});

  factory PromotionModel.fromJson(Map<String, dynamic> json) => PromotionModel(
        promotionId: json["promotionId"],
        promotionName: json["promotionName"],
        promotionDescription: json["promotionDescription"],
        discountPercent: json["discountPercent"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        status: json["status"],
        image: json["image"],
      );
}
