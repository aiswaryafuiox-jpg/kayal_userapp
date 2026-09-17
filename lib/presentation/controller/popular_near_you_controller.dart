import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
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

  final restaurants = <RestaurantItem>[
    RestaurantItem(
      name: 'Pizza Hub',
      image: 'assets/images/homeimg.png',
      cuisine: 'Italian Pizza',
      deliveryTime: '25-30 mins',
      distance: '2.8 Km',
      openingTime: '10:00 Am - 11:00 Pm',
      isOpen: true,
    ),
    RestaurantItem(
      name: 'Pizza Hub',
      image: 'assets/images/homeimg.png',
      cuisine: 'Italian Pizza',
      deliveryTime: '25-30 mins',
      distance: '2.8 Km',
      openingTime: 'Opens at - 10:00 Am',
      isOpen: false,
    ),
    RestaurantItem(
      name: 'Pizza Hub',
      image: 'assets/images/homeimg.png',
      cuisine: 'Italian Pizza',
      deliveryTime: '25-30 mins',
      distance: '2.8 Km',
      openingTime: '10:00 Am - 11:00 Pm',
      isOpen: true,
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPopularRestaurants();
  }

  Future<void> fetchPopularRestaurants() async {
    try {
      isLoading.value = true;
      final response = await _popularRestaurantsUseCase();
      if (response.success && response.data.isNotEmpty) {
        restaurants.assignAll(
          response.data.map(
            (item) => RestaurantItem(
              name: item.name,
              image: (item.image != null && item.image!.isNotEmpty)
                  ? item.image!
                  : 'assets/images/homeimg.png',
              cuisine: item.cuisine ?? 'Italian Pizza',
              deliveryTime: item.deliveryTime ?? '25-30 mins',
              distance: item.distance ?? '2.8 Km',
              openingTime: item.openingTime ?? '10:00 Am - 11:00 Pm',
              isOpen: item.isOpen,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('fetchPopularRestaurants error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onRestaurantTap(RestaurantItem restaurant) {
    Get.toNamed(AppRoutes.category, arguments: restaurant);
  }
}
