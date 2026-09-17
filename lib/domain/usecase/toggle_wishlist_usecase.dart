import 'package:kayal_userapp/data/model/toggle_wishlist_response_model.dart';
import 'package:kayal_userapp/domain/repository/toggle_wishlist_repository.dart';

class ToggleWishlistUseCase {
  final ToggleWishlistRepository _repository;

  ToggleWishlistUseCase(this._repository);

  Future<ToggleWishlistResponseModel> call({
    required dynamic productId,
  }) async {
    return await _repository.toggleWishlist(
      productId: productId,
    );
  }
}
