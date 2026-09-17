import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/get_terms_response_model.dart';
import 'package:kayal_userapp/domain/repository/get_terms_repository.dart';

class GetTermsRepositoryImpl implements GetTermsRepository {
  final ApiService _apiService;

  GetTermsRepositoryImpl(this._apiService);

  @override
  Future<GetTermsResponseModel> getTerms() async {
    try {
      final response = await _apiService.get(ApiRoutes.getTerms);
      return GetTermsResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return GetTermsResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to fetch terms and conditions');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
