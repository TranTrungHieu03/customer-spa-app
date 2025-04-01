import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/ghn_repositoty.dart';

class GetLeadTimeParams {
  final int fromDistrictId;
  final String fromWardCode;
  final int toDistrictId;
  final String toWardCode;
  final int serviceId;

  GetLeadTimeParams({
    required this.fromDistrictId,
    required this.fromWardCode,
    required this.toDistrictId,
    required this.toWardCode,
    required this.serviceId,
  });

  Map<String, dynamic> toJson() => {
        "from_district_id": fromDistrictId,
        "from_ward_code": fromWardCode,
        "to_district_id": toDistrictId,
        "to_ward_code": toWardCode,
        "service_id": serviceId,
      };
}

class GetLeadTime implements UseCase<Either, GetLeadTimeParams> {
  final GHNRepository _repository;

  GetLeadTime(this._repository);

  @override
  Future<Either<Failure, String>> call(GetLeadTimeParams params) async {
    AppLogger.wtf("Múi giờ Mobile: ${DateTime.now().timeZoneName}");

    return await _repository.getLeadTime(params);
  }
}
