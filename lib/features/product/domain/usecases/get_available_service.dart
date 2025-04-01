import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/product/domain/repository/ghn_repositoty.dart';

class GetAvailableServiceParams {
  final int shopId;
  final int fromDistrict;
  final int toDistrict;

  GetAvailableServiceParams({
    required this.shopId,
    required this.fromDistrict,
    required this.toDistrict,
  });

  Map<String, dynamic> toJson() => {
        "shop_id": shopId,
        "from_district": fromDistrict,
        "to_district": toDistrict,
      };
}

class GetAvailableService implements UseCase<Either, GetAvailableServiceParams> {
  final GHNRepository _repository;

  const GetAvailableService(this._repository);

  @override
  Future<Either> call(GetAvailableServiceParams params) async {
    return await _repository.getAvailableService(params);
  }
}
