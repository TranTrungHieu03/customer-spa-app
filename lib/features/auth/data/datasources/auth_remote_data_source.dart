import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/auth/domain/usecases/forget_password.dart';
import 'package:spa_mobile/features/auth/domain/usecases/login.dart';
import 'package:spa_mobile/features/auth/domain/usecases/login_with_facebook.dart';
import 'package:spa_mobile/features/auth/domain/usecases/login_with_google.dart';
import 'package:spa_mobile/features/auth/domain/usecases/resend_otp.dart';
import 'package:spa_mobile/features/auth/domain/usecases/reset_password.dart';
import 'package:spa_mobile/features/auth/domain/usecases/sign_up.dart';
import 'package:spa_mobile/features/auth/domain/usecases/verify_otp.dart';
import 'package:spa_mobile/features/user/domain/usecases/update_profile.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(LoginParams params);

  Future<String> loginWithGoogle(LoginWithGoogleParams params);

  Future<String> loginWithFacebook(LoginWithFacebookParams params);

  Future<String> signUp(SignUpParams params);

  Future<String> verifyOtp(VerifyOtpParams params);

  Future<String> forgetPassword(ForgetPasswordParams params);

  Future<String> resetPassword(ResetPasswordParams params);

  Future<String> resendOtp(ResendOtpParams params);

  Future<UserModel> getUserInfo();

  Future<UserModel> updateProfile(UpdateProfileParams params);

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final NetworkApiService _apiServices;

  AuthRemoteDataSourceImpl(this._apiServices);

  @override
  Future<String> login(LoginParams params) async {
    try {
      final response = await _apiServices.postApi('/Auth/login', params.toJson());

      final apiResponse = ApiResponse<String>.fromJson(response);

      if (apiResponse.success) {
        return apiResponse.result!.data!;
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> signUp(SignUpParams params) async {
    try {
      final response = await _apiServices.postApi('/Auth/first-step', params.toJson());

      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        AppLogger.info(apiResponse!.result!.message);
        return apiResponse.result!.message!;
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> loginWithGoogle(LoginWithGoogleParams params) async {
    try {
      final response = await _apiServices.postApi('/Auth/login-google', params.toJson());

      final apiResponse = ApiResponse<String>.fromJson(response);

      if (apiResponse.success) {
        return apiResponse.result!.data!;
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> verifyOtp(VerifyOtpParams params) async {
    try {
      final response = await _apiServices.postApi("/Auth/submit-otp", params.toJson());

      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return apiResponse.result!.message!;
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> forgetPassword(ForgetPasswordParams params) async {
    try {
      final response = await _apiServices.postApi("/Auth/forget-password?email=${params.email}", {});

      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return apiResponse.result!.message!;
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> resendOtp(ResendOtpParams params) async {
    try {
      final response = await _apiServices.getApi("/Auth/resend-otp?email=${params.email}");

      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return apiResponse.result!.message!;
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> resetPassword(ResetPasswordParams params) async {
    try {
      final response = await _apiServices.postApi("/Auth/update-password?email=${params.email}", params.toJson());

      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return apiResponse.result!.message!;
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> loginWithFacebook(LoginWithFacebookParams params) async {
    try {
      final response = await _apiServices.postApi('/Auth/login-facebook', params.toJson());

      final apiResponse = ApiResponse<String>.fromJson(response);

      if (apiResponse.success) {
        AppLogger.info(apiResponse.result!.data);
        return apiResponse.result!.data!;
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<UserModel> getUserInfo() async {
    try {
      final response = await _apiServices.getApi('/Auth/user-info');

      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return UserModel.fromJson(apiResponse.result!.data!);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      _apiServices.clearTokenCache();
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<UserModel> updateProfile(UpdateProfileParams params) async {
    try {
      final response = await _apiServices.postApi('/Auth/update-user-info', await params.toFormData());
      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return UserModel.fromJson(apiResponse.result!.data!);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
