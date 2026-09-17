import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/verify_login_otp_response_model.dart';
import 'package:kayal_userapp/domain/repository/verify_login_otp_repository.dart';

class VerifyLoginOtpRepositoryImpl implements VerifyLoginOtpRepository {
  final ApiService _apiService;

  VerifyLoginOtpRepositoryImpl(this._apiService);

  @override
  Future<VerifyLoginOtpResponseModel> verifyLoginOtp({
    required String phoneNumber,
    required String otpCode,
  }) async {
    try {
      final response = await _apiService.post(
        ApiRoutes.verifyLoginOtp,
        useFormData: true,
        data: {
          'phone_number': phoneNumber,
          'otp_code': otpCode,
        },
      );

      return VerifyLoginOtpResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return VerifyLoginOtpResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to verify login OTP');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
