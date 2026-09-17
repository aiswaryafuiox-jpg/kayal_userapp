import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/add_to_cart_from_wishlist_response_model.dart';
import 'package:kayal_userapp/domain/repository/add_to_cart_from_wishlist_repository.dart';

class AddToCartFromWishlistRepositoryImpl implements AddToCartFromWishlistRepository {
  final ApiService _apiService;

  AddToCartFromWishlistRepositoryImpl(this._apiService);

  @override
  Future<AddToCartFromWishlistResponseModel> addToCartFromWishlist({
    required dynamic productId,
    dynamic quantity,
  }) async {
    try {
      final int? parsedId = int.tryParse(productId.toString());
      final dynamic validProductId = (parsedId != null && parsedId > 0) ? parsedId : productId;

      final Map<String, dynamic> data = {
        'product_id': validProductId.toString(),
      };
      if (quantity != null) {
        final int? parsedQty = int.tryParse(quantity.toString());
        if (parsedQty != null && parsedQty > 0) {
          data['quantity'] = parsedQty.toString();
        }
      }

      final response = await _apiService.post(
        ApiRoutes.addToCartFromWishlist,
        useFormData: true,
        data: data,
      );

      return AddToCartFromWishlistResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return AddToCartFromWishlistResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      return AddToCartFromWishlistResponseModel(
        success: false,
        message: e.message ?? 'Failed to add wishlist item to cart',
      );
    } catch (e) {
      return AddToCartFromWishlistResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
