import 'package:kayal_userapp/data/model/remove_cart_item_response_model.dart';

abstract class RemoveCartItemRepository {
  Future<RemoveCartItemResponseModel> removeCartItem({
    required dynamic cartId,
  });
}
