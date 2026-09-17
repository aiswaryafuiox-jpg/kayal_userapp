import 'package:kayal_userapp/data/model/place_order_response_model.dart';
import 'package:kayal_userapp/domain/repository/place_order_repository.dart';

class PlaceOrderUseCase {
  final PlaceOrderRepository _repository;

  PlaceOrderUseCase(this._repository);

  Future<PlaceOrderResponseModel> call({
    required dynamic addressId,
    required String paymentMethod,
    String? specialInstructions,
    String? tipAmount,
  }) async {
    return await _repository.placeOrder(
      addressId: addressId,
      paymentMethod: paymentMethod,
      specialInstructions: specialInstructions,
      tipAmount: tipAmount,
    );
  }
}
