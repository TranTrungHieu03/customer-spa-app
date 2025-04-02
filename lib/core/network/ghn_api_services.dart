import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/network/base_api_services.dart';

class GhnApiService implements BaseApiServices {
  final Dio _dio;

  GhnApiService({required String baseUrl, required String token, required String shopId})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: {
              "token": token,
              "shopId": shopId,
              "X-Timezone": "Asia/Ho_Chi_Minh",
            },
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );

  @override
  Future deleteApi(String url) {
    // TODO: implement deleteApi
    throw UnimplementedError();
  }

  @override
  Future<dynamic> getApi(String url) async {
    dynamic responseJson;
    try {
      final response = await _dio.get(url);
      responseJson = response.data;
      if (kDebugMode) {
        AppLogger.info('🔗 Request URL: $url');
        AppLogger.info('📄 Response Data: $responseJson');
      }
      return responseJson;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  void _handleDioException(DioException e) {
    AppLogger.error('❌ DioException: ${e.message}');
    AppLogger.error('📄 Response Data: ${e.response?.data}');
    AppLogger.error('🔗 Request Data: ${e.requestOptions.data}');
    AppLogger.error('🔗 Request Headers: ${e.requestOptions.headers}');
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      throw FetchDataException('Network request timed out');
    } else if (e.type == DioExceptionType.badResponse) {
      throw FetchDataException('Bad response: ${e.response?.statusMessage}');
    } else if (e.type == DioExceptionType.badResponse) {
      throw FetchDataException('Bad response: ${e.response?.statusMessage}');
    } else if (e.type == DioExceptionType.connectionError) {
      throw NoInternetException('No internet connection');
    }
    throw FetchDataException('Try again later');
  }

  @override
  Future postApi(String url, data) async {
    if (kDebugMode) {
      AppLogger.debug(data);
    }

    dynamic responseJson;
    try {
      final Response response = await _dio.post(
        url,
        data: data,
      );

      responseJson = response.data;
      if (kDebugMode) {
        AppLogger.debug(responseJson);
        // AppLogger.debug(response.headers);
      }
      return responseJson;
    } on DioException catch (e) {
      if (kDebugMode) {
        AppLogger.error(e.message);
        AppLogger.error(e.response);
        AppLogger.error(e.error);
        AppLogger.error(e.requestOptions);
      }
      if (e.type == DioExceptionType.badResponse) {
        throw AppException(e.response?.data['message'] ?? 'Lỗi không xác định');
      } else {
        _handleDioException(e);
      }
    }
  }

  @override
  Future putApi(String url, data) {
    // TODO: implement putApi
    throw UnimplementedError();
  }
}
