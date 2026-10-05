import 'package:kayal_userapp/data/model/restaurant_products_response_model.dart';
import 'package:kayal_userapp/domain/repository/restaurant_products_repository.dart';

class RestaurantProductsUseCase {
  final RestaurantProductsRepository _repository;

  RestaurantProductsUseCase(this._repository);

  Future<RestaurantProductsResponseModel> call({
    required dynamic restaurantId,
    required dynamic categoryId,
  }) async {
    return await _repository.getRestaurantProducts(
      restaurantId: restaurantId,
      categoryId: categoryId,
    );
  }
}
