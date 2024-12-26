import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/service/data/model/category_model.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryModel>>> getListCategories();
}
