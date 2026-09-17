import 'package:kayal_userapp/data/model/category_products_response_model.dart';

abstract class CategoryProductsRepository {
  Future<CategoryProductsResponseModel> getCategoryProducts({
    required dynamic categoryId,
  });
}
