import 'package:get/get.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';

class PopularNearYouController extends GetxController {
  final radiusText = 'Showing Restaurants within 700M'.obs;

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

  void onRestaurantTap(RestaurantItem restaurant) {
    Get.toNamed(AppRoutes.category, arguments: restaurant);
  }
}
