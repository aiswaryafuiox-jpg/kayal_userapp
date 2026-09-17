import 'package:kayal_userapp/data/model/get_order_details_response_model.dart';
import 'package:kayal_userapp/domain/repository/get_order_details_repository.dart';

class GetOrderDetailsUseCase {
  final GetOrderDetailsRepository _repository;

  GetOrderDetailsUseCase(this._repository);

  Future<GetOrderDetailsResponseModel> call({required dynamic orderId}) {
    return _repository.getOrderDetails(orderId: orderId);
  }
}
