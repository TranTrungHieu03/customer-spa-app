import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final int notificationId;
  final int userId;
  final String content;
  final String type;
  final bool isRead;
  final int objectId;
  final DateTime createdDate;
  final DateTime updatedDate;

  Notification({
    required this.notificationId,
    required this.userId,
    required this.content,
    required this.type,
    required this.isRead,
    required this.objectId,
    required this.createdDate,
    required this.updatedDate,
  });

  @override
  List<Object?> get props => [notificationId, objectId, content];
}
