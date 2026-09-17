import 'package:kayal_userapp/data/model/categories_response_model.dart';
import 'package:kayal_userapp/domain/repository/categories_repository.dart';

class GetCategoriesUseCase {
  final CategoriesRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<CategoriesResponseModel> call() async {
    return await _repository.getCategories();
  }
}
