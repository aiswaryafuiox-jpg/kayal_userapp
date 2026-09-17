import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/re_order_response_model.dart';
import 'package:kayal_userapp/domain/repository/re_order_repository.dart';

class ReOrderRepositoryImpl implements ReOrderRepository {
  final ApiService _apiService;

  ReOrderRepositoryImpl(this._apiService);

  @override
  Future<ReOrderResponseModel> reOrder({required dynamic orderId}) async {
    try {
      final cleanId = orderId.toString().replaceAll('#', '').trim();
      final response = await _apiService.post(
        '${ApiRoutes.reOrder}/$cleanId',
      );
      return ReOrderResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return ReOrderResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to re-order items');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
