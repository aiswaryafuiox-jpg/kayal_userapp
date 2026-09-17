import 'package:kayal_userapp/data/model/order_summary_response_model.dart';

abstract class OrderSummaryRepository {
  Future<OrderSummaryResponseModel> getOrderSummary();
}
