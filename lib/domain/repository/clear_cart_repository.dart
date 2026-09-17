import 'package:kayal_userapp/data/model/clear_cart_response_model.dart';

abstract class ClearCartRepository {
  Future<ClearCartResponseModel> clearCart();
}
