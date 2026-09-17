import 'package:kayal_userapp/data/model/popular_restaurants_response_model.dart';

abstract class PopularRestaurantsRepository {
  Future<PopularRestaurantsResponseModel> getPopularRestaurants();
}
