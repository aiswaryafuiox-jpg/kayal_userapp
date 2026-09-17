import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/toggle_wishlist_response_model.dart';
import 'package:kayal_userapp/domain/repository/toggle_wishlist_repository.dart';

class ToggleWishlistRepositoryImpl implements ToggleWishlistRepository {
  final ApiService _apiService;

  ToggleWishlistRepositoryImpl(this._apiService);

  @override
  Future<ToggleWishlistResponseModel> toggleWishlist({
    required dynamic productId,
  }) async {
    try {
      final response = await _apiService.post(
        ApiRoutes.toggleWishlist,
        useFormData: true,
        data: {
          'product_id': productId.toString(),
        },
      );

      return ToggleWishlistResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return ToggleWishlistResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      return ToggleWishlistResponseModel(
        success: false,
        message: e.message ?? 'Failed to toggle wishlist item',
      );
    } catch (e) {
      return ToggleWishlistResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
