import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/service/data/model/category_model.dart';
import 'package:spa_mobile/features/service/domain/repository/category_repository.dart';

class GetListCategories implements UseCase<Either, NoParams> {
  final CategoryRepository _repository;

  GetListCategories(this._repository);

  @override
  Future<Either<Failure, List<CategoryModel>>> call(NoParams params) async {
    return await _repository.getListCategories();
  }
}
