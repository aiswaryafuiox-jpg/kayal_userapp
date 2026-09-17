import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/get_wishlist_response_model.dart';
import 'package:kayal_userapp/domain/repository/get_wishlist_repository.dart';

class GetWishlistRepositoryImpl implements GetWishlistRepository {
  final ApiService _apiService;

  GetWishlistRepositoryImpl(this._apiService);

  @override
  Future<GetWishlistResponseModel> getWishlist() async {
    try {
      final response = await _apiService.get(
        ApiRoutes.getWishlist,
      );

      return GetWishlistResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return GetWishlistResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      return GetWishlistResponseModel(
        success: false,
        message: e.message ?? 'Failed to get wishlist',
      );
    } catch (e) {
      return GetWishlistResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
