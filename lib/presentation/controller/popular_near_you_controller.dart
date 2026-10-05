import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/repository/popular_restaurants_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/popular_restaurants_usecase.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';

class PopularNearYouController extends GetxController {
  final PopularRestaurantsUseCase _popularRestaurantsUseCase;

  PopularNearYouController({PopularRestaurantsUseCase? popularRestaurantsUseCase})
      : _popularRestaurantsUseCase = popularRestaurantsUseCase ??
            (sl.isRegistered<PopularRestaurantsUseCase>()
                ? sl<PopularRestaurantsUseCase>()
                : PopularRestaurantsUseCase(
                    PopularRestaurantsRepositoryImpl(ApiService())));

  final radiusText = 'Showing Restaurants within 700M'.obs;
  final RxBool isLoading = false.obs;

  final restaurants = <RestaurantItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPopularRestaurants();
  }

  Future<void> fetchPopularRestaurants({double? lat, double? lng}) async {
    try {
      isLoading.value = true;
      final response = await _popularRestaurantsUseCase(lat: lat, lng: lng);
      if (response.success && response.data.isNotEmpty) {
        restaurants.assignAll(
          response.data.map(
            (item) => RestaurantItem(
              id: item.id,
              name: item.name.capitalizeWords(),
              image: (item.image != null && item.image!.isNotEmpty)
                  ? item.image!
                  : 'assets/images/homeimg.png',
              cuisine: (item.cuisine ?? 'Italian Pizza').capitalizeWords(),
              deliveryTime: item.deliveryTime ?? '25-30 mins',
              distance: item.distance ?? '2.8 Km',
              openingTime: item.openingTime ?? '10:00 Am - 11:00 Pm',
              isOpen: item.isOpen,
            ),
          ),
        );
      } else {
        restaurants.clear();
      }
    } catch (e) {
      debugPrint('fetchPopularRestaurants error: $e');
      restaurants.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void onRestaurantTap(RestaurantItem restaurant) {
    Get.toNamed(
      AppRoutes.product,
      arguments: {
        'restaurant': restaurant,
        'restaurantId': restaurant.id,
        'category': restaurant.name,
        'categoryId': 1,
        'isClosed': !restaurant.isOpen,
        'notes': !restaurant.isOpen
            ? 'This restaurant is currently unavailable.\n${restaurant.openingTime}'
            : null,
      },
    );
  }
}
