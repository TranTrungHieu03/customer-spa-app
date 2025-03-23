import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/data/models/location_model.dart';
import 'package:spa_mobile/features/home/domain/repositories/location_repository.dart';
import 'package:spa_mobile/features/service/domain/repository/branch_repository.dart';

// class GetNearestBranch implements UseCase<Either, NoParams> {
//   final BranchRepository _branchRepository;
//   final LocationRepository _locationRepository;
//
//   GetNearestBranch(this._locationRepository, this._branchRepository);
//
//   @override
//   Future<Either> call(NoParams params) async {
//     LocationModel locationModel = await _locationRepository.getLocation();
//   }
// }
