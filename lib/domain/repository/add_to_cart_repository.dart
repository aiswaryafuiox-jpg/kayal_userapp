import 'package:kayal_userapp/data/model/add_to_cart_response_model.dart';

abstract class AddToCartRepository {
  Future<AddToCartResponseModel> addToCart({
    required dynamic productId,
    dynamic quantity,
    dynamic sessionId,
  });
}
