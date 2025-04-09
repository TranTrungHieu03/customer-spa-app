import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/product/data/model/list_order_product_model.dart';
import 'package:spa_mobile/features/product/data/model/order_product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/cancel_order.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_history_product.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_order_product_detail.dart';

abstract class OrderRemoteDataSource {
  Future<int> createOrder(CreateOrderParams params);

  Future<OrderProductModel> getOrderProductModel(GetOrderProductDetailParams params);

  Future<ListOrderProductModel> getHistoryProduct(GetHistoryProductParams params);

  Future<String> cancelOrder(CancelOrderParams params);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final NetworkApiService _apiServices;

  OrderRemoteDataSourceImpl(this._apiServices);

  @override
  Future<int> createOrder(CreateOrderParams params) async {
    try {
      final response = await _apiServices.postApi('/Order/create-full', params.toJson());
      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        AppLogger.info(apiResponse.result!.message);
        return (apiResponse.result!.data);
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<ListOrderProductModel> getHistoryProduct(GetHistoryProductParams params) async {
    try {
      final response = await _apiServices.getApi('/Order/history-booking?page=${params.page}&status=${params.status}&orderType=product');
      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return ListOrderProductModel.fromJson(apiResponse.result!.data, apiResponse.result!.pagination);
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<OrderProductModel> getOrderProductModel(GetOrderProductDetailParams params) async {
    try {
      final response = await _apiServices.getApi('/Order/detail-booking?orderId=${params.id}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return OrderProductModel.fromJson(apiResponse.result!.data!);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> cancelOrder(CancelOrderParams params) async {
    try {
      final response = await _apiServices.patchApi('/Order/cancel-order/${params.orderId}?reason=${params.reason}', params.toJson());

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.message!);
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
