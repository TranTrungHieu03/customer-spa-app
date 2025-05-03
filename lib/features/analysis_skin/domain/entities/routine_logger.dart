import 'package:equatable/equatable.dart';

class RoutineLogger extends Equatable {
  final int userRoutineLoggerId;
  final int stepId;
  final int staffId;
  final int userId;
  final DateTime actionDate;
  final String status;
  final String stepLogger;
  final String notes;
  final DateTime createdDate;
  final DateTime updatedDate;

  RoutineLogger({
    required this.userRoutineLoggerId,
    required this.stepId,
    required this.staffId,
    required this.userId,
    required this.actionDate,
    required this.status,
    required this.stepLogger,
    required this.notes,
    required this.createdDate,
    required this.updatedDate,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [userRoutineLoggerId, notes, stepId];
}
