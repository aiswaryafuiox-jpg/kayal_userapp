import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/get_notifications_response_model.dart';
import 'package:kayal_userapp/domain/repository/get_notifications_repository.dart';

class GetNotificationsRepositoryImpl implements GetNotificationsRepository {
  final ApiService _apiService;

  GetNotificationsRepositoryImpl(this._apiService);

  @override
  Future<GetNotificationsResponseModel> getNotifications({int page = 1}) async {
    try {
      final response = await _apiService.get(
        ApiRoutes.getNotifications,
        params: {'page': page},
      );
      return GetNotificationsResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return GetNotificationsResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to fetch notifications');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
