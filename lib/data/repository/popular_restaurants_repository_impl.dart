import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/data/model/popular_restaurants_response_model.dart';
import 'package:kayal_userapp/domain/repository/popular_restaurants_repository.dart';

class PopularRestaurantsRepositoryImpl
    implements PopularRestaurantsRepository {
  final ApiService _apiService;
  final LocalStorageService _storage;

  PopularRestaurantsRepositoryImpl(
    this._apiService, {
    LocalStorageService? storage,
  }) : _storage = storage ?? LocalStorageService();

  @override
  Future<PopularRestaurantsResponseModel> getPopularRestaurants({
    dynamic categoryId,
    double? lat,
    double? lng,
  }) async {
    try {
      final double effectiveLat = lat ?? _storage.getLatitude();
      final double effectiveLng = lng ?? _storage.getLongitude();

      final Map<String, dynamic> params = {};
      if (effectiveLat != 0.0) {
        params['lat'] = effectiveLat;
      }
      if (effectiveLng != 0.0) {
        params['lng'] = effectiveLng;
      }
      if (categoryId != null && categoryId.toString().isNotEmpty) {
        params['category_id'] = categoryId;
      }

      final response = await _apiService.get(
        ApiRoutes.popularRestaurants,
        params: params.isNotEmpty ? params : null,
      );
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

