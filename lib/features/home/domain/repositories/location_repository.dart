import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/home/data/models/address_model.dart';
import 'package:spa_mobile/features/home/data/models/distance_model.dart';
import 'package:spa_mobile/features/home/data/models/location_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_address_auto_complete.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_distance.dart';

abstract class LocationRepository {
  Future<Either<Failure, LocationModel>> getLocation();
  Future<Either<Failure, List<DistanceModel>>> getDistance(GetDistanceParams params);
  Future<Either<Failure, List<AddressModel>>> getAddress(GetAddressAutoCompleteParams params);
}
