import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/login_otp_response_model.dart';
import 'package:kayal_userapp/domain/repository/login_otp_repository.dart';

class LoginOtpRepositoryImpl implements LoginOtpRepository {
  final ApiService _apiService;

  LoginOtpRepositoryImpl(this._apiService);

  @override
  Future<LoginOtpResponseModel> loginOtp({
    required String phoneNumber,
  }) async {
    try {
      final response = await _apiService.post(
        ApiRoutes.loginOtp,
        useFormData: true,
        data: {
          'phone_number': phoneNumber,
        },
      );

      return LoginOtpResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return LoginOtpResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to send login OTP');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
