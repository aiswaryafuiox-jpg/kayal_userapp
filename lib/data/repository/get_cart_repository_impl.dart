import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/data/model/get_cart_response_model.dart';
import 'package:kayal_userapp/domain/repository/get_cart_repository.dart';

class GetCartRepositoryImpl implements GetCartRepository {
  final ApiService _apiService;
  final LocalStorageService _storage = LocalStorageService();

  GetCartRepositoryImpl(this._apiService);

  @override
  Future<GetCartResponseModel> getCart({dynamic sessionId}) async {
    try {
      final session = (sessionId != null && sessionId.toString().trim().isNotEmpty)
          ? sessionId.toString().trim()
          : _storage.getOrCreateSessionId();

      final response = await _apiService.get(
        ApiRoutes.getCart,
        params: {'session_id': session},
      );
      return GetCartResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return GetCartResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to fetch cart');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
