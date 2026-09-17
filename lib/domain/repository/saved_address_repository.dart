import 'package:kayal_userapp/data/model/saved_address_response_model.dart';

abstract class SavedAddressRepository {
  Future<SavedAddressResponseModel> getSavedAddress();
}
