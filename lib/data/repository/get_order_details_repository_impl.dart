import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/get_order_details_response_model.dart';
import 'package:kayal_userapp/domain/repository/get_order_details_repository.dart';

class GetOrderDetailsRepositoryImpl implements GetOrderDetailsRepository {
  final ApiService _apiService;

  GetOrderDetailsRepositoryImpl(this._apiService);

  @override
  Future<GetOrderDetailsResponseModel> getOrderDetails({
    required dynamic orderId,
  }) async {
    try {
      final cleanId = orderId.toString().replaceAll('#', '').trim();
      final response = await _apiService.get(
        '${ApiRoutes.getOrderDetails}/$cleanId',
      );
      return GetOrderDetailsResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return GetOrderDetailsResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to fetch order details');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
