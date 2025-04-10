import 'package:spa_mobile/core/common/model/voucher_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/product/data/model/order_detail_model.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';

class OrderRoutineModel {
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
  // final List<OrderDetailModel> orderDetails;
  // final List<AppointmentModel> appointments;
  final String updatedDate;
  final String createdDate;
  final String? paymentMethod;
  final RoutineModel routine;

  OrderRoutineModel({
    required this.orderId,
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
    // required this.orderDetails,
    // required this.appointments,
    required this.updatedDate,
    required this.createdDate,
    this.paymentMethod,
    required this.routine,
  });

  factory OrderRoutineModel.fromJson(Map<String, dynamic> json) {
    return OrderRoutineModel(
        orderId: json['orderId'],
        orderCode: json['orderCode'],
        customerId: json['customerId'],
        customer: json['customer'] != null ? UserModel.fromJson(json['customer']) : null,
        voucherId: json['voucherId'],
        voucher: json['voucher'] != null ? VoucherModel.fromJson(json['voucher']) : null,
        totalAmount: (json['totalAmount'] as num).toDouble(),
        discountAmount: json['discountAmount'] != null ? (json['discountAmount'] as num).toDouble() : null,
        status: json['status'],
        statusPayment: json['statusPayment'],
        note: json['note'],
        // orderDetails: (json['orderDetails'] as List).map((e) => OrderDetailModel.fromJson(e)).toList(),
        // appointments: (json['appointments'] as List).map((e) => AppointmentModel.fromJson(e)).toList(),
        updatedDate: json['updatedDate'],
        paymentMethod: json['paymentMethod'] ?? 'PayOs',
        routine: RoutineModel.fromJson(json['routine']),
        createdDate: json['createdDate']);
  }
}
