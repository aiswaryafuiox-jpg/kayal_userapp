import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/saved_address_response_model.dart';
import 'package:kayal_userapp/domain/repository/saved_address_repository.dart';

class SavedAddressRepositoryImpl implements SavedAddressRepository {
  final ApiService _apiService;

  SavedAddressRepositoryImpl(this._apiService);

  @override
  Future<SavedAddressResponseModel> getSavedAddress() async {
    try {
      final response = await _apiService.get(ApiRoutes.savedAddress);
      return SavedAddressResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return SavedAddressResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to fetch saved addresses');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
