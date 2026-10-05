import 'package:kayal_userapp/data/model/restaurant_products_response_model.dart';

abstract class RestaurantProductsRepository {
  Future<RestaurantProductsResponseModel> getRestaurantProducts({
    required dynamic restaurantId,
    required dynamic categoryId,
  });
}
