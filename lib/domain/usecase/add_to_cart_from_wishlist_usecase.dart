import 'package:kayal_userapp/data/model/add_to_cart_from_wishlist_response_model.dart';
import 'package:kayal_userapp/domain/repository/add_to_cart_from_wishlist_repository.dart';

class AddToCartFromWishlistUseCase {
  final AddToCartFromWishlistRepository _repository;

  AddToCartFromWishlistUseCase(this._repository);

  Future<AddToCartFromWishlistResponseModel> call({
    required dynamic productId,
    dynamic quantity,
  }) async {
    return await _repository.addToCartFromWishlist(
      productId: productId,
      quantity: quantity,
    );
  }
}
