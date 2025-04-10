import 'package:spa_mobile/core/common/entities/voucher.dart';

class VoucherModel extends Voucher {
  VoucherModel(
      {required super.voucherId,
      required super.code,
      required super.quantity,
      required super.remainQuantity,
      required super.status,
      required super.description,
      required super.discountAmount,
      required super.minOrderAmount,
      required super.validFrom,
      required super.validTo,
      required super.createdDate,
      required super.updatedDate,
      required super.requirePoint});

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      voucherId: json['voucherId'],
      code: json['code'],
      quantity: json['quantity'],
      requirePoint: (json['requirePoint'] ?? 0 as num).toDouble(),
      remainQuantity: json['remainQuantity'],
      status: json['status'],
      description: json['description'],
      discountAmount: (json['discountAmount'] ?? 0 as num).toDouble(),
      minOrderAmount: (json['minOrderAmount'] ?? 0 as num).toDouble(),
      validFrom: DateTime.parse(json['validFrom']).toLocal(),
      validTo: DateTime.parse(json['validTo']).toLocal(),
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: DateTime.parse(json['updatedDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voucherId': voucherId,
      'code': code,
      'quantity': quantity,
      'remainQuantity': remainQuantity,
      'status': status,
      'description': description,
      'discountAmount': discountAmount,
      'minOrderAmount': minOrderAmount,
      'validFrom': validFrom.toIso8601String(),
      'validTo': validTo.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate.toIso8601String(),
    };
  }
}
