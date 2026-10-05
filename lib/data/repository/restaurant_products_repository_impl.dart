import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/restaurant_products_response_model.dart';
import 'package:kayal_userapp/domain/repository/restaurant_products_repository.dart';

class RestaurantProductsRepositoryImpl implements RestaurantProductsRepository {
  final ApiService _apiService;

  RestaurantProductsRepositoryImpl(this._apiService);

  @override
  Future<RestaurantProductsResponseModel> getRestaurantProducts({
    required dynamic restaurantId,
    required dynamic categoryId,
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiRoutes.restaurantProducts}/$restaurantId',
        params: {
          'category_id': categoryId,
        },
      );
      return RestaurantProductsResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return RestaurantProductsResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to fetch restaurant products');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
