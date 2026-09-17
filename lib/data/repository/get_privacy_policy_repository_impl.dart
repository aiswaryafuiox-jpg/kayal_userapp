import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/get_privacy_policy_response_model.dart';
import 'package:kayal_userapp/domain/repository/get_privacy_policy_repository.dart';

class GetPrivacyPolicyRepositoryImpl implements GetPrivacyPolicyRepository {
  final ApiService _apiService;

  GetPrivacyPolicyRepositoryImpl(this._apiService);

  @override
  Future<GetPrivacyPolicyResponseModel> getPrivacyPolicy() async {
    try {
      final response = await _apiService.get(ApiRoutes.getPrivacyPolicy);
      return GetPrivacyPolicyResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return GetPrivacyPolicyResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to fetch privacy policy');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
