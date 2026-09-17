import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/popular_restaurants_response_model.dart';
import 'package:kayal_userapp/domain/repository/popular_restaurants_repository.dart';

class PopularRestaurantsRepositoryImpl
    implements PopularRestaurantsRepository {
  final ApiService _apiService;

  PopularRestaurantsRepositoryImpl(this._apiService);

  @override
  Future<PopularRestaurantsResponseModel> getPopularRestaurants() async {
    try {
      final response = await _apiService.get(ApiRoutes.popularRestaurants);
      return PopularRestaurantsResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return PopularRestaurantsResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to fetch popular restaurants');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
