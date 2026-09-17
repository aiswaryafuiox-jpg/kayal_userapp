import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/offers_response_model.dart';
import 'package:kayal_userapp/domain/repository/offers_repository.dart';

class OffersRepositoryImpl implements OffersRepository {
  final ApiService _apiService;

  OffersRepositoryImpl(this._apiService);

  @override
  Future<OffersResponseModel> getOffers() async {
    try {
      final response = await _apiService.get(ApiRoutes.offers);
      return OffersResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return OffersResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to fetch offers');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
