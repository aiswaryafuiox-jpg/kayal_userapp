import 'package:kayal_userapp/data/model/select_active_address_response_model.dart';

abstract class SelectActiveAddressRepository {
  Future<SelectActiveAddressResponseModel> selectActiveAddress({
    required dynamic addressId,
  });
}
