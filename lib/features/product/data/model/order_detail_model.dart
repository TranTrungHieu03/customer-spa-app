import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/data/model/promotion_model.dart';
import 'package:spa_mobile/features/product/domain/entities/order_detail.dart';

class OrderDetailModel extends OrderDetail {
  final ProductModel product;
  final PromotionModel? promotion;

  const OrderDetailModel(
      {required super.orderDetailId,
      required super.orderId,
      required super.productId,
      required super.quantity,
      required super.unitPrice,
      required super.subTotal,
      required super.status,
      super.promotionId,
      required super.statusPayment,
      required this.product,
      this.promotion});

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      orderDetailId: json['orderDetailId'],
      orderId: json['orderId'],
      productId: json['productId'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'],
      subTotal: json['subTotal'],
      status: json['status'],
      promotionId: json['promotionId'],
      statusPayment: json['statusPayment'],
      product: ProductModel.fromJson(json['product']),
      promotion: json['promotion'] != null ? PromotionModel.fromJson(json['promotion']) : null,
    );
  }
}
