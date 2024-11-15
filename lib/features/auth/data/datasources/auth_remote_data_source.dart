import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/auth/domain/usecases/login.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(LoginParams params);

  Future<String> signUp(String email, String password, String role,
      String userName, String phoneNumber);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkApiService _apiServices;

  AuthRemoteDataSourceImpl(this._apiServices);

  @override
  Future<String> login(LoginParams params) async {
    try {
      final response =
          await _apiServices.postApi('Auth/login', params.toJson());

      final apiResponse = ApiResponse<String>.fromJson(response);

      if (apiResponse.success && apiResponse.result?.data != null) {
        return apiResponse.result!.data!;
      } else {
        throw AppException("Login Failed");
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> signUp(String email, String password, String role,
      String userName, String phoneNumber) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
