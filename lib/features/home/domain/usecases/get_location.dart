import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/domain/repositories/location_repository.dart';

class GetLocation implements UseCase<Either, NoParams> {
  final LocationRepository _repository;

  GetLocation(this._repository);

  @override
  Future<Either> call(NoParams params) async {
    return await _repository.getLocation();
  }
}
