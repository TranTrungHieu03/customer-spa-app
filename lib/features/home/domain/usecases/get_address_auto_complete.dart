import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/home/domain/repositories/location_repository.dart';

class GetAddressAutoCompleteParams {
  final String input;

  GetAddressAutoCompleteParams(this.input);
}

class GetAddressAutoComplete implements UseCase<Either, GetAddressAutoCompleteParams> {
  final LocationRepository _repository;

  GetAddressAutoComplete(this._repository);

  @override
  Future<Either> call(GetAddressAutoCompleteParams params) async {
    return await _repository.getAddress(params);
  }
}
