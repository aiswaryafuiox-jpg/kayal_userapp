import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/product_details_response_model.dart';
import 'package:kayal_userapp/domain/repository/product_details_repository.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  final ApiService _apiService;

  ProductDetailsRepositoryImpl(this._apiService);

  @override
  Future<ProductDetailsResponseModel> getProductDetails({
    required dynamic productId,
  }) async {
    try {
      final response = await _apiService.get(
        '${ApiRoutes.getProductDetails}/$productId',
      );
      return ProductDetailsResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return ProductDetailsResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to fetch product details');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
