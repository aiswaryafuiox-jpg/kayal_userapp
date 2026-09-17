import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/banner_response_model.dart';
import 'package:kayal_userapp/domain/repository/banner_repository.dart';

class BannerRepositoryImpl implements BannerRepository {
  final ApiService _apiService;

  BannerRepositoryImpl(this._apiService);

  @override
  Future<BannerResponseModel> getBanners() async {
    try {
      final response = await _apiService.get(ApiRoutes.banner);
      return BannerResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return BannerResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to fetch banners');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
