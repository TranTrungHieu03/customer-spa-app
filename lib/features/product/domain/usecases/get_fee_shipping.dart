import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/ghn_repositoty.dart';

class GetFeeShipping implements UseCase<Either, GetFeeShippingParams> {
  final GHNRepository _repository;

  GetFeeShipping(this._repository);

  @override
  Future<Either> call(GetFeeShippingParams params) async {
    return await _repository.getShippingFee(params);
  }
}

class GetFeeShippingParams {
  final int fromDistrictId;
  final String fromWardCode;
  final int serviceId;
  final dynamic serviceTypeId;
  final int toDistrictId;
  final String toWardCode;
  final int height;
  final int length;
  final int weight;
  final int width;

  GetFeeShippingParams({
    required this.fromDistrictId,
    required this.fromWardCode,
    required this.serviceId,
    required this.serviceTypeId,
    required this.toDistrictId,
    required this.toWardCode,
    required this.height,
    required this.length,
    required this.weight,
    required this.width,
  });

  Map<String, dynamic> toJson() => {
        "from_district_id": fromDistrictId,
        "from_ward_code": fromWardCode,
        "service_id": serviceId,
        "service_type_id": serviceTypeId,
        "to_district_id": toDistrictId,
        "to_ward_code": toWardCode,
        "height": height,
        "length": length,
        "weight": weight,
        "width": width,
      };
}
