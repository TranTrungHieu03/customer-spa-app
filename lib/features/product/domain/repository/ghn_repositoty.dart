import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/product/data/model/district_model.dart';
import 'package:spa_mobile/features/product/data/model/province_model.dart';
import 'package:spa_mobile/features/product/data/model/ward_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_available_service.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_district.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_fee_shipping.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_lead_time.dart';
import 'package:spa_mobile/features/product/domain/usecases/get_ward.dart';

abstract class GHNRepository {
  Future<Either<Failure, List<ProvinceModel>>> getProvince();

  Future<Either<Failure, List<DistrictModel>>> getDistrict(GetDistrictParams params);

  Future<Either<Failure, List<WardModel>>> getWard(GetWardParams params);

  Future<Either<Failure, int>> getShippingFee(GetFeeShippingParams params);

  Future<Either<Failure, int>> getAvailableService(GetAvailableServiceParams params);

  Future<Either<Failure, String>> getLeadTime(GetLeadTimeParams params);
}
