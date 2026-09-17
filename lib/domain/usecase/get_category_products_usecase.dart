import 'package:kayal_userapp/data/model/category_products_response_model.dart';
import 'package:kayal_userapp/domain/repository/category_products_repository.dart';

class GetCategoryProductsUseCase {
  final CategoryProductsRepository _repository;

  GetCategoryProductsUseCase(this._repository);

  Future<CategoryProductsResponseModel> call({
    required dynamic categoryId,
  }) async {
    return await _repository.getCategoryProducts(
      categoryId: categoryId,
    );
  }
}
