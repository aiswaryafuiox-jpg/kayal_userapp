import 'package:kayal_userapp/data/model/get_wishlist_response_model.dart';
import 'package:kayal_userapp/domain/repository/get_wishlist_repository.dart';

class GetWishlistUseCase {
  final GetWishlistRepository _repository;

  GetWishlistUseCase(this._repository);

  Future<GetWishlistResponseModel> call() async {
    return await _repository.getWishlist();
  }
}
