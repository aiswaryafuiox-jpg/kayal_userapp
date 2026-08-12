import 'dart:async';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // ==============================
  // BANNER
  // ==============================

  final bannerIndex = 0.obs;

  final List<String> banners = [
    'assets/images/banner1.png',
    'assets/images/banner1.png',
    'assets/images/banner1.png',
  ];

  // ==============================
  // CATEGORIES
  // ==============================

  final selectedCategory = 0.obs;

  final List<CategoryItem> categories = [
    CategoryItem(
      name: 'All',
      image: 'assets/images/category_all.png',
    ),
    CategoryItem(
      name: 'Pizza',
      image: 'assets/images/pizza.png',
    ),
    CategoryItem(
      name: 'Biryani',
      image: 'assets/images/biryani.png',
    ),
    CategoryItem(
      name: 'Biryani',
      image: 'assets/images/biryani.png',
    ),
    CategoryItem(
      name: 'Biryani',
      image: 'assets/images/biryani.png',
    ),
  ];

  void selectCategory(int index) {
    selectedCategory.value = index;
  }

  // ==============================
  // BOTTOM NAVIGATION
  // ==============================

  final selectedBottomIndex = 0.obs;

  void changeBottomIndex(int index) {
    if (selectedBottomIndex.value == index) return;
    selectedBottomIndex.value = index;

    if (index == 0) {
      Get.offAllNamed(AppRoutes.home);
    } else if (index == 1) {
      Get.offAllNamed(AppRoutes.category);
    }
  }

  // ==============================
  // RESTAURANTS
  // ==============================

  final restaurants = <RestaurantItem>[
    RestaurantItem(
      name: 'Pizza Hub',
      image: 'assets/images/restaurant.png',
      cuisine: 'Italian Pizza',
      deliveryTime: '25-30 mins',
      distance: '2.8 Km',
      openingTime: '10:00 Am - 11:00 Pm',
      isOpen: true,
    ),
    RestaurantItem(
      name: 'Pizza Hub',
      image: 'assets/images/restaurant.png',
      cuisine: 'Italian Pizza',
      deliveryTime: '25-30 mins',
      distance: '2.8 Km',
      openingTime: '10:00 Am - 11:00 Pm',
      isOpen: false,
    ),
  ].obs;

  // ==============================
  // OFFER
  // ==============================

  final offerRemaining = const Duration(
    hours: 20,
    minutes: 30,
    seconds: 12,
  ).obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startOfferTimer();
  }

  void startOfferTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (offerRemaining.value.inSeconds > 0) {
          offerRemaining.value =
              offerRemaining.value - const Duration(seconds: 1);
        }
      },
    );
  }

  String get formattedOfferTime {
    final duration = offerRemaining.value;

    final hours =
        duration.inHours.toString().padLeft(2, '0');

    final minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');

    final seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // ==============================
  // HEADER ACTIONS
  // ==============================

  void openNotifications() {
    debugPrint('Notification clicked');
  }

  void openFavorites() {
    debugPrint('Favorite clicked');
  }

  void openProfile() {
    debugPrint('Profile clicked');
  }

  void viewAllRestaurants() {
    debugPrint('View all restaurants');
  }

  void viewOffers() {
    debugPrint('View all offers');
  }
}

// =======================================
// CATEGORY MODEL
// =======================================

class CategoryItem {
  final String name;
  final String image;

  CategoryItem({
    required this.name,
    required this.image,
  });
}

// =======================================
// RESTAURANT MODEL
// =======================================

class RestaurantItem {
  final String name;
  final String image;
  final String cuisine;
  final String deliveryTime;
  final String distance;
  final String openingTime;
  final bool isOpen;

  RestaurantItem({
    required this.name,
    required this.image,
    required this.cuisine,
    required this.deliveryTime,
    required this.distance,
    required this.openingTime,
    required this.isOpen,
  });
}