import 'package:kayal_userapp/data/model/get_order_details_response_model.dart';

abstract class GetOrderDetailsRepository {
  Future<GetOrderDetailsResponseModel> getOrderDetails({required dynamic orderId});
}
