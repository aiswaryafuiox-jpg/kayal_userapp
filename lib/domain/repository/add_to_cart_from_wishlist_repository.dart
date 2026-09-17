import 'package:kayal_userapp/data/model/add_to_cart_from_wishlist_response_model.dart';

abstract class AddToCartFromWishlistRepository {
  Future<AddToCartFromWishlistResponseModel> addToCartFromWishlist({
    required dynamic productId,
    dynamic quantity,
  });
}
