import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/signup_profile_response_model.dart';
import 'package:kayal_userapp/domain/repository/signup_profile_repository.dart';

class SignupProfileRepositoryImpl implements SignupProfileRepository {
  final ApiService _apiService;

  SignupProfileRepositoryImpl(this._apiService);

  @override
  Future<SignupProfileResponseModel> signupProfile({
    required String fullName,
  }) async {
    try {
      final response = await _apiService.post(
        ApiRoutes.signupProfile,
        useFormData: true,
        data: {
          'full_name': fullName,
        },
      );

      return SignupProfileResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        return SignupProfileResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to complete signup profile');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
