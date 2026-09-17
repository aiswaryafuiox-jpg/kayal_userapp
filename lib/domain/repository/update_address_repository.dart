import 'package:kayal_userapp/data/model/update_address_response_model.dart';

abstract class UpdateAddressRepository {
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
  });
}
