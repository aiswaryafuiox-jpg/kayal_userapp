import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/resend_login_otp_response_model.dart';
import 'package:kayal_userapp/domain/repository/resend_login_otp_repository.dart';

class ResendLoginOtpRepositoryImpl implements ResendLoginOtpRepository {
  final ApiService _apiService;

  ResendLoginOtpRepositoryImpl(this._apiService);

  @override
  Future<ResendLoginOtpResponseModel> resendLoginOtp({
    required String phoneNumber,
  }) async {
    try {
      final response = await _apiService.post(
        ApiRoutes.resendLoginOtp,
        useFormData: true,
        data: {
          'phone_number': phoneNumber,
        },
      );

      return ResendLoginOtpResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return ResendLoginOtpResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to resend login OTP');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
