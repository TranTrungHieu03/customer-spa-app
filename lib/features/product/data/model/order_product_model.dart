import 'package:spa_mobile/core/common/model/voucher_model.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/product/data/model/order_detail_model.dart';
import 'package:spa_mobile/features/product/data/model/shipment_response_model.dart';

class OrderProductModel {
  final int orderId;
  final int orderCode;
  final int customerId;
  final UserModel? customer;
  final int? voucherId;
  final VoucherModel? voucher;
  final double totalAmount;
  final double? discountAmount;
  final String status;
  final String statusPayment;
  final String? note;
  final List<OrderDetailModel> orderDetails;
  final ShipmentResponseModel? shipment;
  final String updatedDate;

  OrderProductModel(
      {required this.orderId,
      required this.orderCode,
      required this.customerId,
      this.customer,
      this.voucherId,
      this.voucher,
      required this.totalAmount,
      this.discountAmount,
      required this.status,
      required this.statusPayment,
      this.note,
      required this.orderDetails,
      required this.updatedDate,
      this.shipment});

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      orderId: json['orderId'],
      orderCode: json['orderCode'],
      customerId: json['customerId'],
      customer: json['customer'] != null ? UserModel.fromJson(json['customer']) : null,
      voucherId: json['voucherId'],
      voucher: json['voucher'] != null ? VoucherModel.fromJson(json['voucher']) : null,
      totalAmount: json['totalAmount'],
      discountAmount: json['discountAmount'],
      status: json['status'],
      statusPayment: json['statusPayment'],
      note: json['note'],
      orderDetails: (json['orderDetails'] as List<dynamic>).map((e) => OrderDetailModel.fromJson(e)).toList(),
      shipment: json['shipment'] != null ? ShipmentResponseModel.fromJson(json['shipment']) : null,
      updatedDate: json['updatedDate'],
    );
  }
}
