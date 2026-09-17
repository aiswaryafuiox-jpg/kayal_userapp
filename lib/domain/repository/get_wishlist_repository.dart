import 'package:kayal_userapp/data/model/get_wishlist_response_model.dart';

abstract class GetWishlistRepository {
  Future<GetWishlistResponseModel> getWishlist();
}
