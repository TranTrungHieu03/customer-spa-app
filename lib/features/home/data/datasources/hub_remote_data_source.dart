import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/home/data/models/user_chat_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_user_chat_info.dart';

abstract class HubRemoteDataSource {
  Future<UserChatModel> getUserChatInfo(GetUserChatInfoParams params);
}

class HubRemoteDataSourceImpl implements HubRemoteDataSource {
  final NetworkApiService _apiService;

  HubRemoteDataSourceImpl(this._apiService);

  @override
  Future<UserChatModel> getUserChatInfo(GetUserChatInfoParams params) async {
    try {
      final response = await _apiService.getApi('/Hub/get-customer-info/${params.userId}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return apiResponse.result!.data!;
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
