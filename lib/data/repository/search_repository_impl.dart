import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/search_response_model.dart';
import 'package:kayal_userapp/domain/repository/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final ApiService _apiService;

  SearchRepositoryImpl(this._apiService);

  @override
  Future<SearchResponseModel> search({
    required String query,
  }) async {
    try {
      final response = await _apiService.get(
        ApiRoutes.search,
        params: {
          'query': query,
        },
      );

      return SearchResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return SearchResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to perform search');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
