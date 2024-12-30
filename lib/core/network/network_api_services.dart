import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/base_api_services.dart';
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
          _cachedToken = _cachedToken ?? await authService.getToken();

          options.headers['Authorization'] = 'Bearer $_cachedToken';
          options.headers['Content-Type'] = 'application/json';
          if (kDebugMode) {
            print("==> Request Interceptor Triggered");
            print("Token: $_cachedToken");
            print("URL: ${options.uri}");
            print("Headers: ${options.headers}");
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
              final response = await _dio.request(
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
      if (kDebugMode) {
        print("==> Request Refresh Token");
        print("New Token: $newToken");
      }
      if (newToken != null) {
        await authService.saveToken(newToken);
      }
      return newToken;
    } catch (e) {
      print('Failed to refresh token: $e');
      return null;
    }
  }

  /// Sends a GET request to the specified [url] and returns the response.
  ///
  /// Throws a [NoInternetException] if there is no internet connection.
  /// Throws a [FetchDataException] if the network request times out.
  @override
  Future<dynamic> getApi(String url) async {
    if (kDebugMode) {
      print(url);
    }
    dynamic responseJson;
    try {
      final response = await _dio.get(url);
      responseJson = returnResponse(response);

      // } on SocketException {
      //   throw NoInternetException('');
      // } on TimeoutException {
      //   throw FetchDataException('Network Request time out');
      // }

      responseJson = returnResponse(response);
      if (kDebugMode) {
        print(responseJson);
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
      print(url);
      print(data);
    }

    dynamic responseJson;
    try {
      final Response response = await _dio.post(url, data: data);

      responseJson = returnResponse(response);
      if (kDebugMode) {
        print(responseJson);
      }
      return responseJson;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        return returnResponse(e.response!);
      } else {
        _handleDioException(e);
      }
    }

    // } on SocketException {
    //   throw NoInternetException('No Internet Connection');
    // } on TimeoutException {
    //   throw FetchDataException('Network Request time out');
    // }
  }

  void _handleDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw FetchDataException('Request timed out');
    } else if (e.type == DioExceptionType.badResponse) {
      print('Bad response: ${e.response?.statusMessage}');
      throw FetchDataException('Bad response: ${e.response?.statusMessage}');
    } else if (e.type == DioExceptionType.connectionError) {
      throw NoInternetException('No internet connection');
    }
    throw FetchDataException('Unexpected error occurred');
  }

  /// Parses the [response] and returns the corresponding JSON data.
  ///
  /// Throws a [FetchDataException] with the appropriate error message if the response status code is not successful.
  dynamic returnResponse(Response response) {
    if (kDebugMode) {
      print(response.statusCode);
    }

    switch (response.statusCode) {
      case 200:
      case 400:
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
        throw FetchDataException(
            'Error occurred while communicating with server');
    }
  }
}
