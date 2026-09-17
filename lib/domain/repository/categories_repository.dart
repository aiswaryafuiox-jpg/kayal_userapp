import 'package:kayal_userapp/data/model/categories_response_model.dart';

abstract class CategoriesRepository {
  Future<CategoriesResponseModel> getCategories();
}
