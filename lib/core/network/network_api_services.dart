import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/base_api_services.dart';

/// Class for handling network API requests.
class NetworkApiService implements BaseApiServices {
  final Dio _dio;

  // Constructor to initialize Dio and set up the interceptor
  NetworkApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://api.example.com',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        ) {
    // Add the interceptor after Dio is initialized
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = 'Bearer my_token';
          return handler.next(options);
        },
      ),
    );
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
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
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
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
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
        dynamic responseJson = jsonDecode(response.data);
        return responseJson;
      case 400:
        dynamic responseJson = jsonDecode(response.data);
        return responseJson;
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