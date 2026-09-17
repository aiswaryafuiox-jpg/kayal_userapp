import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/logout_response_model.dart';
import 'package:kayal_userapp/domain/repository/logout_repository.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  final ApiService _apiService;

  LogoutRepositoryImpl(this._apiService);

  @override
  Future<LogoutResponseModel> logout() async {
    try {
      final response = await _apiService.post(
        ApiRoutes.logout,
      );

      return LogoutResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return LogoutResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      return LogoutResponseModel(
        success: false,
        message: e.message ?? 'Failed to logout',
      );
    } catch (e) {
      return LogoutResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
