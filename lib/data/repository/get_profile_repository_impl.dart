import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/get_profile_response_model.dart';
import 'package:kayal_userapp/domain/repository/get_profile_repository.dart';

class GetProfileRepositoryImpl implements GetProfileRepository {
  final ApiService _apiService;

  GetProfileRepositoryImpl(this._apiService);

  @override
  Future<GetProfileResponseModel> getProfile() async {
    try {
      final response = await _apiService.get(ApiRoutes.getProfile);
      return GetProfileResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return GetProfileResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to fetch user profile');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
