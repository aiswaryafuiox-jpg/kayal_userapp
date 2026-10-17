import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/data/model/remove_cart_item_response_model.dart';
import 'package:kayal_userapp/domain/repository/remove_cart_item_repository.dart';

class RemoveCartItemRepositoryImpl implements RemoveCartItemRepository {
  final ApiService _apiService;
  final LocalStorageService _storage = LocalStorageService();

  RemoveCartItemRepositoryImpl(this._apiService);

  @override
  Future<RemoveCartItemResponseModel> removeCartItem({
    dynamic productId,
    dynamic cartId,
    dynamic sessionId,
  }) async {
    try {
      final idToUse = productId ?? cartId;
      final session = (sessionId != null && sessionId.toString().trim().isNotEmpty)
          ? sessionId.toString().trim()
          : _storage.getOrCreateSessionId();

      final endpoint = '${ApiRoutes.removeCartItem}/$idToUse';
      final response = await _apiService.post(
        endpoint,
        useFormData: true,
        data: {
          if (idToUse != null) 'product_id': idToUse.toString(),
          'session_id': session,
        },
        queryParameters: {
          'session_id': session,
        },
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
