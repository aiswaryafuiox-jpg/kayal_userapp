import 'package:kayal_userapp/data/model/update_quantity_response_model.dart';
import 'package:kayal_userapp/domain/repository/update_quantity_repository.dart';

class UpdateQuantityUseCase {
  final UpdateQuantityRepository _repository;

  UpdateQuantityUseCase(this._repository);

  Future<UpdateQuantityResponseModel> call({
    required dynamic cartId,
    required dynamic quantity,
  }) async {
    return await _repository.updateQuantity(
      cartId: cartId,
      quantity: quantity,
    );
  }
}
