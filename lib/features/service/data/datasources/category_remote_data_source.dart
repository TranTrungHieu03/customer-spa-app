import 'package:spa_mobile/core/errors/exceptions.dart';
import 'package:spa_mobile/core/network/network.dart';
import 'package:spa_mobile/core/response/api_response.dart';
import 'package:spa_mobile/features/service/data/model/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getListCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final NetworkApiService _apiServices;

  CategoryRemoteDataSourceImpl(this._apiServices);

  @override
  Future<List<CategoryModel>> getListCategories() async {
    try {
      final response = await _apiServices.getApi('/Category/get-all-categories?page=1&pageSize=20');
      final apiResponse = ApiResponse.fromJson(response);
      if (apiResponse.success) {
        return apiResponse.result!.data != null && apiResponse.result!.data is List
            ? (apiResponse.result!.data! as List).map((serviceJson) => CategoryModel.fromJson(serviceJson)).toList()
            : [];
      } else {
        throw AppException(apiResponse.result!.message);
      }
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
