import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/update_address_response_model.dart';
import 'package:kayal_userapp/domain/repository/update_address_repository.dart';

class UpdateAddressRepositoryImpl implements UpdateAddressRepository {
  final ApiService _apiService;

  UpdateAddressRepositoryImpl(this._apiService);

  @override
  Future<UpdateAddressResponseModel> updateAddress({
    required dynamic addressId,
    String? fullName,
    String? phoneNumber,
    String? pincode,
    String? address,
    String? landmark,
    String? locationType,
    String? city,
    String? state,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final dataMap = <String, dynamic>{};

      if (fullName != null && fullName.trim().isNotEmpty) {
        dataMap['full_name'] = fullName.trim();
      }
      if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
        dataMap['phone_number'] = phoneNumber.trim();
      }
      if (pincode != null && pincode.trim().isNotEmpty) {
        dataMap['pincode'] = pincode.trim();
      }
      if (address != null && address.trim().isNotEmpty) {
        dataMap['address'] = address.trim();
      }
      if (landmark != null && landmark.trim().isNotEmpty) {
        dataMap['landmark'] = landmark.trim();
      }
      if (locationType != null && locationType.trim().isNotEmpty) {
        dataMap['location_type'] = locationType.trim();
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
        '${ApiRoutes.updateAddress}/$cleanAddressId',
        useFormData: true,
        data: dataMap,
      );

      return UpdateAddressResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return UpdateAddressResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to update address');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
