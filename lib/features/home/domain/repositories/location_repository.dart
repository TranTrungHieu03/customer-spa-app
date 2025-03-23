import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/home/data/models/location_model.dart';

abstract class LocationRepository {
  Future<Either<Failure, LocationModel>> getLocation();
}
