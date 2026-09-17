import 'package:kayal_userapp/data/model/add_address_response_model.dart';

abstract class AddAddressRepository {
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
  });
}
