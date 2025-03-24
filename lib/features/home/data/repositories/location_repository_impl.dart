import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/home/data/datasources/location_remote_data_source.dart';
import 'package:spa_mobile/features/home/data/models/distance_model.dart';
import 'package:spa_mobile/features/home/data/models/location_model.dart';
import 'package:spa_mobile/features/home/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource _dataSource;

  LocationRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, LocationModel>> getLocation() async {
    try {
      final LocationModel response = await _dataSource.getAddress();
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DistanceModel>>> getDistance(params) async {
    try {
      final List<DistanceModel> response = await _dataSource.getDistance(params);
      return right(response);
    } catch (e) {
      return left(ApiFailure(message: e.toString()));
    }
  }
}
