import 'package:kayal_userapp/data/model/get_cart_response_model.dart';
import 'package:kayal_userapp/domain/repository/get_cart_repository.dart';

class GetCartUseCase {
  final GetCartRepository _repository;

  GetCartUseCase(this._repository);

  Future<GetCartResponseModel> call() async {
    return await _repository.getCart();
  }
}
