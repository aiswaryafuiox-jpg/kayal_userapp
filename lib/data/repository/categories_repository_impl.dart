import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/categories_response_model.dart';
import 'package:kayal_userapp/domain/repository/categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final ApiService _apiService;

  CategoriesRepositoryImpl(this._apiService);

  @override
  Future<CategoriesResponseModel> getCategories() async {
    try {
      final response = await _apiService.get(ApiRoutes.getCategories);
      return CategoriesResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return CategoriesResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to fetch categories');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
