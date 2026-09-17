import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/initiate_payment_response_model.dart';
import 'package:kayal_userapp/domain/repository/initiate_payment_repository.dart';

class InitiatePaymentRepositoryImpl implements InitiatePaymentRepository {
  final ApiService _apiService;

  InitiatePaymentRepositoryImpl(this._apiService);

  @override
  Future<InitiatePaymentResponseModel> initiatePayment({
    required dynamic orderId,
    required dynamic amount,
  }) async {
    try {
      final response = await _apiService.post(
        ApiRoutes.initiatePayment,
        useFormData: true,
        data: {
          'order_id': orderId.toString(),
          'amount': amount.toString(),
        },
      );

      return InitiatePaymentResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return InitiatePaymentResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to initiate payment');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
