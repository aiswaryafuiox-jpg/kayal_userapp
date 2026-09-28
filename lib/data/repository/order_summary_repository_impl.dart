import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/order_summary_response_model.dart';
import 'package:kayal_userapp/domain/repository/order_summary_repository.dart';

class OrderSummaryRepositoryImpl implements OrderSummaryRepository {
  final ApiService _apiService;

  OrderSummaryRepositoryImpl(this._apiService);

  @override
  Future<OrderSummaryResponseModel> getOrderSummary({dynamic sessionId}) async {
    try {
      final Map<String, dynamic>? params =
          (sessionId != null && sessionId.toString().isNotEmpty)
              ? {'session_id': sessionId.toString()}
              : null;
      final response = await _apiService.get(
        ApiRoutes.getOrderSummary,
        params: params,
      );
      return OrderSummaryResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return OrderSummaryResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to fetch order summary');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
