import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/store_food_review_response_model.dart';
import 'package:kayal_userapp/domain/repository/store_food_review_repository.dart';

class StoreFoodReviewRepositoryImpl implements StoreFoodReviewRepository {
  final ApiService _apiService;

  StoreFoodReviewRepositoryImpl(this._apiService);

  @override
  Future<StoreFoodReviewResponseModel> storeFoodReview({
    required dynamic foodId,
    required String rating,
    required String review,
  }) async {
    try {
      final response = await _apiService.post(
        '${ApiRoutes.storeFoodReview}/$foodId',
        data: {
          'rating': rating,
          'review': review,
        },
        useFormData: true,
      );

      return StoreFoodReviewResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return StoreFoodReviewResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      return StoreFoodReviewResponseModel(
        success: false,
        message: e.message ?? 'Failed to submit review',
      );
    } catch (e) {
      return StoreFoodReviewResponseModel(
        success: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }
}
