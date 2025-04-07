import 'package:equatable/equatable.dart';

class Shipment extends Equatable {
  final String name;
  final String phone;
  final String address;
  final String expectedDeliveryTime;
  final String status;
  final String orderTime;
  final double cost;

  const Shipment({
    required this.name,
    required this.phone,
    required this.address,
    required this.expectedDeliveryTime,
    required this.status,
    required this.orderTime,
    required this.cost
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        name,
        phone,
        address,
        expectedDeliveryTime,
        status,
      ];
}
