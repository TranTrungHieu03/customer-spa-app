import 'package:spa_mobile/features/home/domain/entities/notification.dart';

class NotificationModel extends Notification {
  NotificationModel(
      {required super.notificationId,
      required super.userId,
      required super.content,
      required super.type,
      required super.isRead,
      required super.objectId,
      required super.createdDate,
      required super.updatedDate});

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        notificationId: json["notificationId"],
        userId: json["userId"],
        content: json["content"],
        type: json["type"],
        isRead: json["isRead"],
        objectId: json["objectId"],
        createdDate: DateTime.parse(json["createdDate"]),
        updatedDate: DateTime.parse(json["updatedDate"]),
      );

  Map<String, dynamic> toJson() => {
        "notificationId": notificationId,
        "userId": userId,
        "content": content,
        "type": type,
        "isRead": isRead,
        "objectId": objectId,
        "createdDate": createdDate.toIso8601String(),
        "updatedDate": updatedDate.toIso8601String(),
      };
}
