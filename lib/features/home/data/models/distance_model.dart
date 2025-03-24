import 'package:spa_mobile/features/home/domain/entities/distance.dart';

class DistanceModel extends Distance {
  DistanceModel({required super.value, required super.text});

  factory DistanceModel.fromJson(Map<String, dynamic> json) {
    return DistanceModel(value: json['distance']['value'], text: json['distance']['text']);
  }
}
