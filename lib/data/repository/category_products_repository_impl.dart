import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/category_products_response_model.dart';
import 'package:kayal_userapp/domain/repository/category_products_repository.dart';

class CategoryProductsRepositoryImpl implements CategoryProductsRepository {
  final ApiService _apiService;

  CategoryProductsRepositoryImpl(this._apiService);

  @override
  Future<CategoryProductsResponseModel> getCategoryProducts({
    required dynamic categoryId,
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiRoutes.getCategoryProducts}/$categoryId',
      );
      return CategoryProductsResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return CategoryProductsResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to fetch category products');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
