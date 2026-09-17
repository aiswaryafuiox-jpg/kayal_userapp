import 'package:kayal_userapp/data/model/place_order_response_model.dart';

abstract class PlaceOrderRepository {
  Future<PlaceOrderResponseModel> placeOrder({
    required dynamic addressId,
    required String paymentMethod,
    String? specialInstructions,
    String? tipAmount,
  });
}
