import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/select_active_address_response_model.dart';
import 'package:kayal_userapp/domain/repository/select_active_address_repository.dart';

class SelectActiveAddressRepositoryImpl implements SelectActiveAddressRepository {
  final ApiService _apiService;

  SelectActiveAddressRepositoryImpl(this._apiService);

  @override
  Future<SelectActiveAddressResponseModel> selectActiveAddress({
    required dynamic addressId,
  }) async {
    try {
      dynamic cleanAddressId = addressId;
      if (addressId != null) {
        if (addressId is num) {
          cleanAddressId = addressId.toInt();
        } else {
          final str = addressId.toString().trim();
          final parsed = int.tryParse(str);
          if (parsed != null) {
            cleanAddressId = parsed;
          } else {
            final match = RegExp(r'\d+').firstMatch(str);
            if (match != null) {
              cleanAddressId = int.tryParse(match.group(0)!) ?? str;
            }
          }
        }
      }

      final response = await _apiService.post(
        '${ApiRoutes.selectActiveAddress}/$cleanAddressId',
      );

      return SelectActiveAddressResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return SelectActiveAddressResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to select active address');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
