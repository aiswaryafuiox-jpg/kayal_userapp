import 'package:kayal_userapp/data/model/add_to_cart_response_model.dart';
import 'package:kayal_userapp/domain/repository/add_to_cart_repository.dart';

class AddToCartUseCase {
  final AddToCartRepository _repository;

  AddToCartUseCase(this._repository);

  Future<AddToCartResponseModel> call({
    required dynamic productId,
    dynamic quantity,
    dynamic sessionId,
  }) async {
    return await _repository.addToCart(
      productId: productId,
      quantity: quantity,
      sessionId: sessionId,
    );
  }
}
