import 'package:kayal_userapp/data/model/re_order_response_model.dart';
import 'package:kayal_userapp/domain/repository/re_order_repository.dart';

class ReOrderUseCase {
  final ReOrderRepository _repository;

  ReOrderUseCase(this._repository);

  Future<ReOrderResponseModel> call({required dynamic orderId}) {
    return _repository.reOrder(orderId: orderId);
  }
}
