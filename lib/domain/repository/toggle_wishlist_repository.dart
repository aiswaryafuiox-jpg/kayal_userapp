import 'package:kayal_userapp/data/model/toggle_wishlist_response_model.dart';

abstract class ToggleWishlistRepository {
  Future<ToggleWishlistResponseModel> toggleWishlist({
    required dynamic productId,
  });
}
