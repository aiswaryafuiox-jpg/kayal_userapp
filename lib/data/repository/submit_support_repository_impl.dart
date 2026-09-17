import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/submit_support_response_model.dart';
import 'package:kayal_userapp/domain/repository/submit_support_repository.dart';

class SubmitSupportRepositoryImpl implements SubmitSupportRepository {
  final ApiService _apiService;

  SubmitSupportRepositoryImpl(this._apiService);

  @override
  Future<SubmitSupportResponseModel> submitSupport({
    required String title,
    required String description,
  }) async {
    try {
      final response = await _apiService.post(
        ApiRoutes.submitSupport,
        data: {
          'title': title,
          'description': description,
        },
        useFormData: true,
      );

      return SubmitSupportResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return SubmitSupportResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      return SubmitSupportResponseModel(
        success: false,
        message: e.message ?? 'Failed to submit support request',
      );
    } catch (e) {
      return SubmitSupportResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
