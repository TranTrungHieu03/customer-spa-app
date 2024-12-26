import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Service extends Equatable {
  final int serviceId;
  final String name;
  final String description;
  final double price;
  final String duration;

  final String status;
  final int categoryId;

  // final Category category;

  const Service({
    required this.serviceId,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.status,
    required this.categoryId,
    // required this.category
  });

  Service copyWith(
          {int? serviceId,
          String? name,
          String? description,
          double? price,
          String? duration,
          String? status,
          int? categoryId,
          Category? category}) =>
      Service(
        serviceId: serviceId ?? this.serviceId,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        duration: duration ?? this.duration,
        status: status ?? this.status,
        categoryId: categoryId ?? this.categoryId,
        // category: category ?? this.category
      );

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
