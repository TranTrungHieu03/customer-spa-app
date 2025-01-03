import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_ai_chat.dart';

abstract class AiChatRemoteDataSource {
  Future<String> getAiChat(GetAiChatParams params);
}

class AiChatRemoteDataSourceImpl implements AiChatRemoteDataSource {
  final NetworkApiService _apiService;

  AiChatRemoteDataSourceImpl(this._apiService);

  @override
  Future<String> getAiChat(GetAiChatParams params) async {
    try {
      final response =
          await _apiService.postApi('/BotChat/send', params.toJson());

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
