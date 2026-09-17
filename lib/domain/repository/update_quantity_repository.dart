import 'package:kayal_userapp/data/model/update_quantity_response_model.dart';

abstract class UpdateQuantityRepository {
  Future<UpdateQuantityResponseModel> updateQuantity({
    required dynamic cartId,
    required dynamic quantity,
  });
}
