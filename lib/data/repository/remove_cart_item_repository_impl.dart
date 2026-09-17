import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/remove_cart_item_response_model.dart';
import 'package:kayal_userapp/domain/repository/remove_cart_item_repository.dart';

class RemoveCartItemRepositoryImpl implements RemoveCartItemRepository {
  final ApiService _apiService;

  RemoveCartItemRepositoryImpl(this._apiService);

  @override
  Future<RemoveCartItemResponseModel> removeCartItem({
    required dynamic cartId,
  }) async {
    try {
      final endpoint = '${ApiRoutes.removeCartItem}/$cartId';
      final response = await _apiService.post(
        endpoint,
      );

      return RemoveCartItemResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return RemoveCartItemResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      return RemoveCartItemResponseModel(
        success: false,
        message: e.message ?? 'Failed to remove cart item',
      );
    } catch (e) {
      return RemoveCartItemResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
