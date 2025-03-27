import 'package:spa_mobile/features/home/domain/entities/location.dart';

class LocationModel extends Location {
  LocationModel({required super.address, required super.formatAddress});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(address: json[''], formatAddress: json['']);
  }
}
