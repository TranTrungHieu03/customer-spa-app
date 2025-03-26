import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/product/data/datasources/ghn_remote_data_source.dart';
import 'package:spa_mobile/features/product/data/model/district_model.dart';
import 'package:spa_mobile/features/product/data/model/province_model.dart';
import 'package:spa_mobile/features/product/data/model/ward_model.dart';
import 'package:spa_mobile/features/product/domain/repository/ghn_repositoty.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_district.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_fee_shipping.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_ward.dart';

class GHNRepositoryImpl implements GHNRepository {
  final GHNRemoteDataSource _ghnRemoteDataSource;

  GHNRepositoryImpl(this._ghnRemoteDataSource);

  @override
  Future<Either<Failure, List<DistrictModel>>> getDistrict(GetDistrictParams params) async {
    try {
      List<DistrictModel> result = await _ghnRemoteDataSource.getDistrict(params);
      return right(result);
    } on AppException catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<ProvinceModel>>> getProvince() async {
    try {
      List<ProvinceModel> result = await _ghnRemoteDataSource.getProvince();
      return right(result);
    } on AppException catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, int>> getShippingFee(GetFeeShippingParams params) async {
    try {
      int result = await _ghnRemoteDataSource.getFeeShipping(params);
      return right(result);
    } on AppException catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Either<Failure, List<WardModel>>> getWard(GetWardParams params) async {
    try {
      List<WardModel> result = await _ghnRemoteDataSource.getWard(params);
      return right(result);
    } on AppException catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }
}
