import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/auth/domain/usecases/login.dart';
import 'package:spa_mobile/features/auth/domain/usecases/login_with_google.dart';
import 'package:spa_mobile/features/auth/domain/usecases/sign_up.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(LoginParams params);

  Future<String> loginWithGoogle(LoginWithGoogleParams params);

  Future<String> signUp(SignUpParams params);
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
  Future<String> signUp(SignUpParams params) async {
    try {
      final response =
          await _apiServices.postApi('Auth/first-step', params.toJson());

      final apiResponse = ApiResponse<String>.fromJson(response);

      if (apiResponse.success && apiResponse.result?.data != null) {
        return apiResponse.result!.data!;
      } else {
        throw AppException("Register account failed");
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> loginWithGoogle(LoginWithGoogleParams params) async {
    try {
      final response =
          await _apiServices.postApi('Auth/loginWithGoogle', params.toJson());

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
}
