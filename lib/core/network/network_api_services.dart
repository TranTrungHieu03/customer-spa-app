import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/network/base_api_services.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/service/auth_service.dart';

/// Class for handling network API requests.
class NetworkApiService implements BaseApiServices {
  final Dio _dio;
  final AuthService authService;
  String? _cachedToken;

  // Constructor to initialize Dio and set up the interceptor
  NetworkApiService({required String baseUrl, required this.authService})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        ) {
    // Add the interceptor after Dio is initialized
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          _cachedToken = _cachedToken ??= await authService.getToken();

          options.headers['Authorization'] = 'Bearer $_cachedToken';
          options.headers['Content-Type'] = 'application/json';
          if (kDebugMode) {
            AppLogger.info("==> Request Interceptor Triggered \nToken: $_cachedToken\nURL: ${options.uri}\nHeaders: ${options.headers}");
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          // Handle token refresh on 401 Unauthorized error
          if (error.response?.statusCode == 401) {
            final newToken = await _refreshToken();
            if (newToken != null) {
              _cachedToken = newToken;

              // Retry the failed request with new token
              final options = error.requestOptions;
              options.headers['Authorization'] = 'Bearer $newToken';
              if (kDebugMode) {
                AppLogger.warning("==> Retry Request with new token: $newToken\nURL: ${options.uri}\nHeaders: ${options.headers}");
              }

              // final response = options.data is FormData
              //     ? await _dio.request(
              //         options.path,
              //         options: Options(
              //           method: options.method,
              //           headers: {...options.headers, "Content-Type": "multipart/form-data"},
              //         ),
              //         data: FormData.fromMap(Map.fromEntries((options.data as FormData).fields)),
              //         queryParameters: options.queryParameters,
              //       )
              //     : await _dio.request(
              //         options.path,
              //         options: Options(
              //           method: options.method,
              //           headers: options.headers,
              //         ),
              //         data: options.data,
              //         queryParameters: options.queryParameters,
              //       );
              final response = options.data is FormData
                  ? await _dio.request(
                options.path,
                options: Options(
                  method: options.method,
                  headers: options.headers,
                ),
                data: options.data, // Giữ nguyên FormData
                queryParameters: options.queryParameters,
              )
                  : await _dio.request(
                options.path,
                options: Options(
                  method: options.method,
                  headers: options.headers,
                ),
                data: options.data,
                queryParameters: options.queryParameters,
              );
              return handler.resolve(response);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<String?> _refreshToken() async {
    try {
      final response = await _dio.get('/Auth/refresh-token');
      final newToken = response.data['result']['data'] as String?;
      if (newToken != null) {
        await authService.saveToken(newToken);
        _cachedToken = newToken;
        return newToken;
      }
    } catch (e) {
      AppLogger.info('Failed to refresh token: $e');
      _handleSessionExpired();
    }
    return null;
  }

  void _handleSessionExpired() {
    AppLogger.info('Session expired. Redirecting to login...');
    goLoginNotBack();
  }


  /// Sends a GET request to the specified [url] and returns the response.
  ///
  /// Throws a [NoInternetException] if there is no internet connection.
  /// Throws a [FetchDataException] if the network request times out.
  @override
  Future<dynamic> getApi(String url) async {
    dynamic responseJson;
    try {
      final response = await _dio.get(url);
      responseJson = returnResponse(response);

      if (kDebugMode) {
        // AppLogger.debug(responseJson);
      }
      return responseJson;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        return returnResponse(e.response!);
      } else {
        _handleDioException(e);
      }
    }
  }

  /// Sends a POST request to the specified [url] with the provided [data]
  /// and returns the response.
  ///
  /// Throws a [NoInternetException] if there is no internet connection.
  /// Throws a [FetchDataException] if the network request times out.
  @override
  Future<dynamic> postApi(String url, dynamic data) async {
    if (kDebugMode) {
      AppLogger.debug(data);
    }

    dynamic responseJson;
    try {
      AppLogger.debug("1######### ${data is FormData}");
      if (data is FormData) {
        AppLogger.debug("FormData fields: ${data.fields}");
        AppLogger.debug("FormData files: ${data.files}");
      }
      // final Options? options = data is FormData
      //     ? Options(headers: {'Content-Type': 'multipart/form-data'})
      //     : null;

      final Response response = await _dio.post(
        url,
        data: data,
      );
      responseJson = returnResponse(response);
      if (kDebugMode) {
        AppLogger.debug(responseJson);
      }
      return responseJson;
    } on DioException catch (e) {
      if (kDebugMode) {
        AppLogger.error(e);
      }
      if (e.type == DioExceptionType.badResponse) {
        return returnResponse(e.response!);
      } else {
        _handleDioException(e);
      }
    }
  }

  void _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
      throw FetchDataException('Network request timed out');
    } else if (e.type == DioExceptionType.badResponse) {
      throw FetchDataException('Bad response: ${e.response?.statusMessage}');
    } else if (e.type == DioExceptionType.connectionError) {
      throw NoInternetException('No internet connection');
    }
    throw FetchDataException('Try again later');
  }

  /// Parses the [response] and returns the corresponding JSON data.
  ///
  /// Throws a [FetchDataException] with the appropriate error message if the response status code is not successful.
  dynamic returnResponse(Response response) {
    if (kDebugMode) {
      AppLogger.debug(response.statusCode);
    }

    switch (response.statusCode) {
      case 200:
      case 400:
        AppLogger.debug(response.data);
        if (response.data is String) {
          return jsonDecode(response.data);
        } else {
          return response.data;
        }
      case 401:
        throw UnauthorisedException(response.data.toString());
      case 500:
      case 404:
        throw BadRequestException(response.data.toString());
      default:
        throw FetchDataException('Error occurred while communicating with server');
    }
  }

  void clearTokenCache() {
    _cachedToken = null;
    if (kDebugMode) {
      AppLogger.info("==> Token cache cleared");
    }
  }

  @override
  Future uploadFileApi(File path) {
    // TODO: implement uploadFileApi
    throw UnimplementedError();
  }
}
