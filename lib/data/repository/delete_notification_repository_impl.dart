import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/delete_notification_response_model.dart';
import 'package:kayal_userapp/domain/repository/delete_notification_repository.dart';

class DeleteNotificationRepositoryImpl implements DeleteNotificationRepository {
  final ApiService _apiService;

  DeleteNotificationRepositoryImpl(this._apiService);

  @override
  Future<DeleteNotificationResponseModel> deleteNotification({
    required dynamic notificationId,
  }) async {
    try {
      final cleanId = notificationId.toString().replaceAll('#', '').trim();
      final response = await _apiService.post(
        '${ApiRoutes.deleteNotification}/$cleanId',
      );
      return DeleteNotificationResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return DeleteNotificationResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to delete notification');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
