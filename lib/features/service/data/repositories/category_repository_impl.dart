import 'package:dartz/dartz.dart';
import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/errors/failure.dart';
import 'package:spa_mobile/features/service/data/datasources/category_remote_data_source.dart';
import 'package:spa_mobile/features/service/data/model/category_model.dart';
import 'package:spa_mobile/features/service/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
 final CategoryRemoteDataSource _categoryRemoteDataSource;

  CategoryRepositoryImpl(this._categoryRemoteDataSource);

  @override
  Future<Either<Failure, List<CategoryModel>>> getListCategories() async {
    try {
      List<CategoryModel> result =
          await _categoryRemoteDataSource.getListCategories();
      return right(result);
    } on AppException catch (e) {
      return left(ApiFailure(
        message: e.toString(),
      ));
    }
  }
}
