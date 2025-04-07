import 'package:spa_mobile/features/product/domain/entities/shipment.dart';

class ShipmentResponseModel extends Shipment {
  const ShipmentResponseModel(
      {required super.name,
      required super.phone,
      required super.address,
      required super.expectedDeliveryTime,
      required super.status,
      required super.orderTime,
      required super.cost});

  factory ShipmentResponseModel.fromJson(Map<String, dynamic> json) {
    return ShipmentResponseModel(
      name: json['recipientName'],
      phone: json['recipientPhone'],
      address: json['recipientAddress'],
      expectedDeliveryTime: json['estimatedDeliveryDate'],
      status: json['shippingStatus'],
      orderTime: json['createdDate'],
      cost: json['shippingCost'] != null ? double.parse(json['shippingCost'].toString()) : 0.0,
    );
  }
}
