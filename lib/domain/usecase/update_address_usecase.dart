import 'package:kayal_userapp/data/model/update_address_response_model.dart';
import 'package:kayal_userapp/domain/repository/update_address_repository.dart';

class UpdateAddressUseCase {
  final UpdateAddressRepository _repository;

  UpdateAddressUseCase(this._repository);

  Future<UpdateAddressResponseModel> call({
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
    return await _repository.updateAddress(
      addressId: addressId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      pincode: pincode,
      address: address,
      landmark: landmark,
      locationType: locationType,
      city: city,
      state: state,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
