import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/service/domain/entities/time.dart';

class TimeModel extends Time {
  const TimeModel({required super.startTime, required super.endTime});

  factory TimeModel.fromJson(Map<String, dynamic> json) {
    AppLogger.info(json);
    return TimeModel(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'TimeModel(startTime: ${startTime.toIso8601String()}, endTime: ${endTime.toIso8601String()})';
  }
}
