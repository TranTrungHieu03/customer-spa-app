import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/network/ghn_api_services.dart';
import 'package:spa_mobile/features/product/data/model/district_model.dart';
import 'package:spa_mobile/features/product/data/model/province_model.dart';
import 'package:spa_mobile/features/product/data/model/ward_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_available_service.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_district.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_fee_shipping.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_lead_time.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_ward.dart';

abstract class GHNRemoteDataSource {
  Future<List<ProvinceModel>> getProvince();

  Future<List<DistrictModel>> getDistrict(GetDistrictParams params);

  Future<List<WardModel>> getWard(GetWardParams params);

  Future<int> getFeeShipping(GetFeeShippingParams params);

  Future<String> getLeadTime(GetLeadTimeParams params);

  Future<int> getAvailableService(GetAvailableServiceParams params);
}

class GHNRemoteDataSourceImpl implements GHNRemoteDataSource {
  final GhnApiService _apiServices;

  GHNRemoteDataSourceImpl(this._apiServices);

  @override
  Future<List<DistrictModel>> getDistrict(GetDistrictParams params) async {
    try {
      final response = await _apiServices.getApi('shiip/public-api/master-data/district?province_id=${params.provinceId}');
      if (response['code'] == 200) {
        return (response['data'] as List).map((x) => DistrictModel.fromJson(x)).toList();
      } else {
        throw AppException("Có lõi trong quá trình chuyển đổi dữ liệu");
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<ProvinceModel>> getProvince() async {
    try {
      final response = await _apiServices.getApi('shiip/public-api/master-data/province');
      if (response['code'] == 200) {
        return (response['data'] as List).map((x) => ProvinceModel.fromJson(x)).toList();
      } else {
        throw AppException("Có lõi trong quá trình chuyển đổi dữ liệu");
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<WardModel>> getWard(GetWardParams params) async {
    try {
      final response = await _apiServices.getApi('shiip/public-api/master-data/ward?district_id=${params.districtId}');
      if (response['code'] == 200) {
        return (response['data'] as List).map((x) => WardModel.fromJson(x)).toList();
      } else {
        throw AppException("Có lõi trong quá trình chuyển đổi dữ liệu");
      }
    } catch (e) {
      AppLogger.info(e.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<int> getFeeShipping(GetFeeShippingParams params) async {
    try {
      final response = await _apiServices.postApi('shiip/public-api/v2/shipping-order/fee', params.toJson());

      if (response['code'] == 200) {
        return response['data']['total'];
      } else {
        throw AppException("Có lõi trong quá trình chuyển đổi dữ liệu");
      }
    } catch (e) {
      AppLogger.info(e.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> getLeadTime(GetLeadTimeParams params) async {
    try {
      final response = await _apiServices.postApi('shiip/public-api/v2/shipping-order/leadtime', params.toJson());
      if (response['code'] == 200) {
        return response['data']['leadtime_order']['to_estimate_date'];
      } else {
        throw AppException("Có lõi trong quá trình chuyển đổi dữ liệu");
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<int> getAvailableService(GetAvailableServiceParams params) async {
    try {
      final response = await _apiServices.postApi('shiip/public-api/v2/shipping-order/available-services', params.toJson());
      if (response['code'] == 200) {
        return response['data'][0]['service_id'];
      } else {
        throw AppException("Có lõi trong quá trình chuyển đổi dữ liệu");
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
