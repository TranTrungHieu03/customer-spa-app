import 'package:equatable/equatable.dart';

class OrderDetail extends Equatable {
  final int orderDetailId;
  // final int orderId;
  // final int productId;
  // final int? promotionId;
  final int quantity;
  final double unitPrice;
  final double subTotal;
  final double? discountAmount;
  final String status;
  final String statusPayment;

  const OrderDetail({
    required this.orderDetailId,
    // required this.orderId,
    // required this.productId,
    // this.promotionId,
    required this.quantity,
    required this.unitPrice,
    required this.subTotal,
    this.discountAmount,
    required this.status,
    required this.statusPayment,
  });

  @override
  List<Object?> get props => [
        orderDetailId,
        // orderId,
        // productId,
        // promotionId,
        quantity,
        unitPrice,
        subTotal,
        discountAmount,
        status,
        statusPayment,
      ];
}
