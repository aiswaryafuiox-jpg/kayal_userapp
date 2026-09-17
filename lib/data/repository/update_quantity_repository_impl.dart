import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/update_quantity_response_model.dart';
import 'package:kayal_userapp/domain/repository/update_quantity_repository.dart';

class UpdateQuantityRepositoryImpl implements UpdateQuantityRepository {
  final ApiService _apiService;

  UpdateQuantityRepositoryImpl(this._apiService);

  @override
  Future<UpdateQuantityResponseModel> updateQuantity({
    required dynamic cartId,
    required dynamic quantity,
  }) async {
    try {
      final endpoint = '${ApiRoutes.updateQuantity}/$cartId';
      final int parsedQuantity = (int.tryParse(quantity.toString()) ?? 1).clamp(0, 999);

      final response = await _apiService.post(
        endpoint,
        useFormData: true,
        data: {
          'quantity': parsedQuantity.toString(),
        },
      );

      return UpdateQuantityResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return UpdateQuantityResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      return UpdateQuantityResponseModel(
        success: false,
        message: e.message ?? 'Failed to update cart quantity',
      );
    } catch (e) {
      return UpdateQuantityResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
