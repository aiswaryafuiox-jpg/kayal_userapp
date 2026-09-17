import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/verify_signup_otp_response_model.dart';
import 'package:kayal_userapp/domain/repository/verify_signup_otp_repository.dart';

class VerifySignupOtpRepositoryImpl implements VerifySignupOtpRepository {
  final ApiService _apiService;

  VerifySignupOtpRepositoryImpl(this._apiService);

  @override
  Future<VerifySignupOtpResponseModel> verifySignupOtp({
    required String phoneNumber,
    required String otpCode,
  }) async {
    try {
      final response = await _apiService.post(
        ApiRoutes.verifySignupOtp,
        useFormData: true,
        data: {
          'phone_number': phoneNumber,
          'otp_code': otpCode,
        },
      );

      return VerifySignupOtpResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return VerifySignupOtpResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to verify OTP');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
