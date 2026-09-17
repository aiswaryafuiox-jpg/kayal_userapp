import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/store_user_feedback_response_model.dart';
import 'package:kayal_userapp/domain/repository/store_user_feedback_repository.dart';

class StoreUserFeedbackRepositoryImpl implements StoreUserFeedbackRepository {
  final ApiService _apiService;

  StoreUserFeedbackRepositoryImpl(this._apiService);

  @override
  Future<StoreUserFeedbackResponseModel> storeUserFeedback({
    required String message,
  }) async {
    try {
      final response = await _apiService.post(
        ApiRoutes.storeUserFeedback,
        data: {
          'message': message,
        },
        useFormData: true,
      );

      return StoreUserFeedbackResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return StoreUserFeedbackResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      return StoreUserFeedbackResponseModel(
        success: false,
        message: e.message ?? 'Failed to submit feedback',
      );
    } catch (e) {
      return StoreUserFeedbackResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
