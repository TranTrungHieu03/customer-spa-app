import 'package:spa_mobile/features/service/data/model/time_model.dart';

class StaffTimeModel {
  final int staffId;
  final List<TimeModel> busyTimes;

  StaffTimeModel({
    required this.staffId,
    required this.busyTimes,
  });

  factory StaffTimeModel.fromJson(Map<String, dynamic> json) {
    return StaffTimeModel(
      staffId: json['staffId'],
      busyTimes: (json['busyTimes'] as List).map((e) => TimeModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staffId': staffId,
      'busyTimes': busyTimes.map((e) => e.toJson()).toList(),
    };
  }
}
