import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/clear_cart_response_model.dart';
import 'package:kayal_userapp/domain/repository/clear_cart_repository.dart';

class ClearCartRepositoryImpl implements ClearCartRepository {
  final ApiService _apiService;

  ClearCartRepositoryImpl(this._apiService);

  @override
  Future<ClearCartResponseModel> clearCart() async {
    try {
      final response = await _apiService.post(
        ApiRoutes.clearCart,
      );

      return ClearCartResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return ClearCartResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      return ClearCartResponseModel(
        success: false,
        message: e.message ?? 'Failed to clear cart',
      );
    } catch (e) {
      return ClearCartResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
