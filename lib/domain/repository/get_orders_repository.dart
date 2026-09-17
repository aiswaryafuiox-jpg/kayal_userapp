import 'package:kayal_userapp/data/model/get_orders_response_model.dart';

abstract class GetOrdersRepository {
  Future<GetOrdersResponseModel> getOrders({int page = 1});
}
