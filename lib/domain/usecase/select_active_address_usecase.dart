import 'package:kayal_userapp/data/model/select_active_address_response_model.dart';
import 'package:kayal_userapp/domain/repository/select_active_address_repository.dart';

class SelectActiveAddressUseCase {
  final SelectActiveAddressRepository _repository;

  SelectActiveAddressUseCase(this._repository);

  Future<SelectActiveAddressResponseModel> call({
    required dynamic addressId,
  }) async {
    return await _repository.selectActiveAddress(
      addressId: addressId,
    );
  }
}
