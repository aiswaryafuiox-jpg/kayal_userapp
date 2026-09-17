import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/add_address_response_model.dart';
import 'package:kayal_userapp/domain/repository/add_address_repository.dart';

class AddAddressRepositoryImpl implements AddAddressRepository {
  final ApiService _apiService;

  AddAddressRepositoryImpl(this._apiService);

  @override
  Future<AddAddressResponseModel> addAddress({
    required String fullName,
    required String phoneNumber,
    required String pincode,
    required String address,
    String? landmark,
    required String locationType,
    String? city,
    String? state,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final dataMap = <String, dynamic>{
        'full_name': fullName,
        'phone_number': phoneNumber,
        'pincode': pincode,
        'address': address,
        'location_type': locationType,
      };

      if (landmark != null && landmark.trim().isNotEmpty) {
        dataMap['landmark'] = landmark.trim();
      }
      if (city != null && city.trim().isNotEmpty) {
        dataMap['city'] = city.trim();
      }
      if (state != null && state.trim().isNotEmpty) {
        dataMap['state'] = state.trim();
      }
      if (latitude != null) {
        dataMap['latitude'] = latitude;
      }
      if (longitude != null) {
        dataMap['longitude'] = longitude;
      }

      final response = await _apiService.post(
        ApiRoutes.addAddress,
        useFormData: true,
        data: dataMap,
      );

      return AddAddressResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return AddAddressResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to add address');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
