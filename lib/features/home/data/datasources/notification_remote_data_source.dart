import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/list_notification_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_all_notification.dart';
import 'package:spa_mobile/features/home/domain/usecases/mark_as_read.dart';
import 'package:spa_mobile/features/home/domain/usecases/mark_as_read_all.dart';

abstract class NotificationRemoteDataSource {
  Future<String> markAsRead(MarkAsReadParams params);

  Future<ListNotificationModel> getListNotification(GetAllNotificationParams params);

  Future<String> markAsReadAll(MarkAsReadAllParams params);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final NetworkApiService _apiService;

  NotificationRemoteDataSourceImpl(this._apiService);

  @override
  Future<ListNotificationModel> getListNotification(GetAllNotificationParams params) async {
    try {
      final response = await _apiService.getApi(
          '/Notification/get-all?userId=${params.userId}&pageIndex=${params.pageIndex}&pageSize=${params.pageSize}${params.isRead != null ? '&isRead=false' : ""}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return ListNotificationModel.fromJson(apiResponse.result!.data!, apiResponse.result!.pagination);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> markAsRead(MarkAsReadParams params) async {
    try {
      final response = await _apiService.postApi('/Notification/mark-as-read', params.toJson());

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return apiResponse!.result!.message!;
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> markAsReadAll(MarkAsReadAllParams params) async {
    try {
      final response = await _apiService.getApi('/Notification/mark-as-read-all?userId=${params.userId}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return apiResponse!.result!.message!;
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
