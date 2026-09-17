import 'package:kayal_userapp/data/model/remove_cart_item_response_model.dart';
import 'package:kayal_userapp/domain/repository/remove_cart_item_repository.dart';

class RemoveCartItemUseCase {
  final RemoveCartItemRepository _repository;

  RemoveCartItemUseCase(this._repository);

  Future<RemoveCartItemResponseModel> call({
    required dynamic cartId,
  }) async {
    return await _repository.removeCartItem(
      cartId: cartId,
    );
  }
}
