import 'package:kayal_userapp/data/model/popular_restaurants_response_model.dart';
import 'package:kayal_userapp/domain/repository/popular_restaurants_repository.dart';

class PopularRestaurantsUseCase {
  final PopularRestaurantsRepository _repository;

  PopularRestaurantsUseCase(this._repository);

  Future<PopularRestaurantsResponseModel> call() async {
    return await _repository.getPopularRestaurants();
  }
}
