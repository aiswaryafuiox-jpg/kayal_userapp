import 'package:kayal_userapp/data/model/saved_address_response_model.dart';
import 'package:kayal_userapp/domain/repository/saved_address_repository.dart';

class GetSavedAddressUseCase {
  final SavedAddressRepository _repository;

  GetSavedAddressUseCase(this._repository);

  Future<SavedAddressResponseModel> call() async {
    return await _repository.getSavedAddress();
  }
}
