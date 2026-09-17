import 'package:kayal_userapp/data/model/order_summary_response_model.dart';
import 'package:kayal_userapp/domain/repository/order_summary_repository.dart';

class GetOrderSummaryUseCase {
  final OrderSummaryRepository _repository;

  GetOrderSummaryUseCase(this._repository);

  Future<OrderSummaryResponseModel> call() async {
    return await _repository.getOrderSummary();
  }
}
