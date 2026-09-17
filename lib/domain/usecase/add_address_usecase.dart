import 'package:kayal_userapp/data/model/add_address_response_model.dart';
import 'package:kayal_userapp/domain/repository/add_address_repository.dart';

class AddAddressUseCase {
  final AddAddressRepository _repository;

  AddAddressUseCase(this._repository);

  Future<AddAddressResponseModel> call({
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
    return await _repository.addAddress(
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
