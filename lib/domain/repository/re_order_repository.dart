import 'package:kayal_userapp/data/model/re_order_response_model.dart';

abstract class ReOrderRepository {
  Future<ReOrderResponseModel> reOrder({required dynamic orderId});
}
