import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/get_orders_response_model.dart';
import 'package:kayal_userapp/domain/repository/get_orders_repository.dart';

class GetOrdersRepositoryImpl implements GetOrdersRepository {
  final ApiService _apiService;

  GetOrdersRepositoryImpl(this._apiService);

  @override
  Future<GetOrdersResponseModel> getOrders({int page = 1}) async {
    try {
      final response = await _apiService.get(
        ApiRoutes.getOrders,
        params: page > 1 ? {'page': page} : null,
      );
      return GetOrdersResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return GetOrdersResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to fetch orders');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
