import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/mark_as_read_response_model.dart';
import 'package:kayal_userapp/domain/repository/mark_as_read_repository.dart';

class MarkAsReadRepositoryImpl implements MarkAsReadRepository {
  final ApiService _apiService;

  MarkAsReadRepositoryImpl(this._apiService);

  @override
  Future<MarkAsReadResponseModel> markAsRead({
    required dynamic notificationId,
  }) async {
    try {
      final cleanId = notificationId.toString().replaceAll('#', '').trim();
      final response = await _apiService.post(
        '${ApiRoutes.markAsRead}/$cleanId',
      );
      return MarkAsReadResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return MarkAsReadResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to mark notification as read');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
