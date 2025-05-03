import 'package:spa_mobile/core/common/model/pagination_model.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/home/data/models/notification_model.dart';

class ListNotificationModel {
  List<NotificationModel> notifications;
  PaginationModel pagination;

  ListNotificationModel({
    required this.notifications,
    required this.pagination,
  });

  factory ListNotificationModel.fromJson(List<dynamic>? json, Map<String, dynamic>? paginationJson) {
    return ListNotificationModel(
      notifications: json != null ? json.map((item) => NotificationModel.fromJson(item)).toList() : [],
      pagination: paginationJson != null ? PaginationModel.fromJson(paginationJson) : PaginationModel.isEmty(),
    );
  }
}
