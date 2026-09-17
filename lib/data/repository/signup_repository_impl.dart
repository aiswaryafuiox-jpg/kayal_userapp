import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/signup_response_model.dart';
import 'package:kayal_userapp/domain/repository/signup_repository.dart';

class SignupRepositoryImpl implements SignupRepository {
  final ApiService _apiService;

  SignupRepositoryImpl(this._apiService);

  @override
  Future<SignupResponseModel> signup({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
  }) async {
    try {
      final response = await _apiService.post(
        ApiRoutes.signup,
        useFormData: true,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'phone_number': phoneNumber,
          'email': email,
        },
      );

      return SignupResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return SignupResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to complete registration');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
