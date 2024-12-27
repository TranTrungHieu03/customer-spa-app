import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final int serviceId;
  final String name;
  final String description;
  final double price;
  final String duration;

  final String status;
  final String? steps;

  const Service({
    required this.serviceId,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.status,
    this.steps,
  });

  Service copyWith(
          {int? serviceId,
          String? name,
          String? description,
          double? price,
          String? duration,
          String? status,
          String? steps}) =>
      Service(
        serviceId: serviceId ?? this.serviceId,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        duration: duration ?? this.duration,
        status: status ?? this.status,
        steps: steps ?? this.steps,
      );

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
