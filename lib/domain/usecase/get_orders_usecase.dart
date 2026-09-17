import 'package:kayal_userapp/data/model/get_orders_response_model.dart';
import 'package:kayal_userapp/domain/repository/get_orders_repository.dart';

class GetOrdersUseCase {
  final GetOrdersRepository _repository;

  GetOrdersUseCase(this._repository);

  Future<GetOrdersResponseModel> call({int page = 1}) {
    return _repository.getOrders(page: page);
  }
}
