import 'package:spa_mobile/core/common/model/voucher_model.dart';
import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_vouchers.dart';

abstract class VoucherRemoteDataSource {
  Future<List<VoucherModel>> getVouchersByDate(GetVouchersParams params);
}

class VoucherRemoteDataSourceImpl implements VoucherRemoteDataSource {
  final NetworkApiService _apiService;

  VoucherRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<VoucherModel>> getVouchersByDate(GetVouchersParams params) async {
    try {
      final response = await _apiService.getApi('/Voucher/get-voucher-by-date?dateTime=${params.date}');

      final apiResponse = ApiResponse.fromJson(response);

      if (apiResponse.success) {
        return (apiResponse.result!.data! as List).map((x) => VoucherModel.fromJson(x)).toList();
      } else {
        throw AppException(apiResponse.result!.message!);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
