import 'package:kayal_userapp/data/model/clear_cart_response_model.dart';
import 'package:kayal_userapp/domain/repository/clear_cart_repository.dart';

class ClearCartUseCase {
  final ClearCartRepository _repository;

  ClearCartUseCase(this._repository);

  Future<ClearCartResponseModel> call() async {
    return await _repository.clearCart();
  }
}
