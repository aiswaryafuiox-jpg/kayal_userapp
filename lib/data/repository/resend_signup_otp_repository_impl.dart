import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/resend_signup_otp_response_model.dart';
import 'package:kayal_userapp/domain/repository/resend_signup_otp_repository.dart';

class ResendSignupOtpRepositoryImpl implements ResendSignupOtpRepository {
  final ApiService _apiService;

  ResendSignupOtpRepositoryImpl(this._apiService);

  @override
  Future<ResendSignupOtpResponseModel> resendSignupOtp({
    required String phoneNumber,
  }) async {
    try {
      final response = await _apiService.post(
        ApiRoutes.resendSignupOtp,
        useFormData: true,
        data: {
          'phone_number': phoneNumber,
        },
      );

      return ResendSignupOtpResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return ResendSignupOtpResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to resend OTP');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
