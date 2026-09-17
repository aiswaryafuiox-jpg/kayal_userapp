import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/banner_response_model.dart';
import 'package:kayal_userapp/data/model/offers_response_model.dart';
import 'package:kayal_userapp/data/repository/banner_repository_impl.dart';
import 'package:kayal_userapp/data/repository/categories_repository_impl.dart';
import 'package:kayal_userapp/data/repository/offers_repository_impl.dart';
import 'package:kayal_userapp/data/repository/popular_restaurants_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/banner_usecase.dart';
import 'package:kayal_userapp/domain/usecase/get_categories_usecase.dart';
import 'package:kayal_userapp/domain/usecase/offers_usecase.dart';
import 'package:kayal_userapp/domain/usecase/popular_restaurants_usecase.dart';

class HomeController extends GetxController {
  final BannerUseCase _bannerUseCase;
  final PopularRestaurantsUseCase _popularRestaurantsUseCase;
  final OffersUseCase _offersUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  HomeController({
    BannerUseCase? bannerUseCase,
    PopularRestaurantsUseCase? popularRestaurantsUseCase,
    OffersUseCase? offersUseCase,
    GetCategoriesUseCase? getCategoriesUseCase,
  })  : _bannerUseCase = bannerUseCase ??
            (sl.isRegistered<BannerUseCase>()
                ? sl<BannerUseCase>()
                : BannerUseCase(BannerRepositoryImpl(ApiService()))),
        _popularRestaurantsUseCase = popularRestaurantsUseCase ??
            (sl.isRegistered<PopularRestaurantsUseCase>()
                ? sl<PopularRestaurantsUseCase>()
                : PopularRestaurantsUseCase(
                    PopularRestaurantsRepositoryImpl(ApiService()))),
        _offersUseCase = offersUseCase ??
            (sl.isRegistered<OffersUseCase>()
                ? sl<OffersUseCase>()
                : OffersUseCase(OffersRepositoryImpl(ApiService()))),
        _getCategoriesUseCase = getCategoriesUseCase ??
            (sl.isRegistered<GetCategoriesUseCase>()
                ? sl<GetCategoriesUseCase>()
                : GetCategoriesUseCase(
                    CategoriesRepositoryImpl(ApiService())));

  // ==============================
  // BANNER
  // ==============================

  final bannerIndex = 0.obs;
  final RxList<BannerItemModel> apiBanners = <BannerItemModel>[].obs;
  final RxBool isBannersLoading = false.obs;

  final List<String> banners = [
    'assets/images/banner1.png',
    'assets/images/banner1.png',
    'assets/images/banner1.png',
  ];

  // ==============================
  // CATEGORIES
  // ==============================

  final selectedCategory = 0.obs;
  final RxBool isCategoriesLoading = false.obs;

  final RxList<CategoryItem> categories = <CategoryItem>[
    CategoryItem(name: 'All', image: 'assets/images/menu1.png'),
    CategoryItem(name: 'Pizza', image: 'assets/images/menu2.png'),
    CategoryItem(name: 'Biryani', image: 'assets/images/menu3.png'),
    CategoryItem(name: 'Meals', image: 'assets/images/menu4.png'),
    CategoryItem(name: 'Noodles', image: 'assets/images/menu5.png'),
  ].obs;

  void selectCategory(int index) {
    selectedCategory.value = index;
  }

  // ==============================
  // BOTTOM NAVIGATION
  // ==============================

  final selectedBottomIndex = 0.obs;
  final pageController = PageController();

  Future<void> changeBottomIndex(int index) async {
    if (selectedBottomIndex.value == index) return;

    selectedBottomIndex.value = index;
    pageController.jumpToPage(index);
  }

  // ==============================
  // RESTAURANTS
  // ==============================

  final RxList<RestaurantItem> restaurants = <RestaurantItem>[
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
  ].obs;
  final RxBool isRestaurantsLoading = false.obs;

  // ==============================
  // OFFERS
  // ==============================

  final RxList<OfferItemModel> apiOffers = <OfferItemModel>[].obs;
  final RxBool isOffersLoading = false.obs;

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
    fetchBanners();
    fetchPopularRestaurants();
    fetchOffers();
    fetchCategories();

    final arguments = Get.arguments;
    if (arguments is Map && arguments['tab'] != null) {
      final int tabIndex = arguments['tab'];
      selectedBottomIndex.value = tabIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          pageController.jumpToPage(tabIndex);
        }
      });
    }
  }

  Future<void> fetchBanners() async {
    try {
      isBannersLoading.value = true;
      final response = await _bannerUseCase();
      if (response.success && response.data.isNotEmpty) {
        apiBanners.assignAll(response.data);
      }
    } catch (e) {
      debugPrint('fetchBanners error: $e');
    } finally {
      isBannersLoading.value = false;
    }
  }

  Future<void> fetchPopularRestaurants() async {
    try {
      isRestaurantsLoading.value = true;
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
      isRestaurantsLoading.value = false;
    }
  }

  Future<void> fetchOffers() async {
    try {
      isOffersLoading.value = true;
      final response = await _offersUseCase();
      if (response.success && response.data.isNotEmpty) {
        apiOffers.assignAll(response.data);
      }
    } catch (e) {
      debugPrint('fetchOffers error: $e');
    } finally {
      isOffersLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      isCategoriesLoading.value = true;
      final response = await _getCategoriesUseCase();
      if (response.success && response.data.isNotEmpty) {
        final List<CategoryItem> apiList = [
          CategoryItem(name: 'All', image: 'assets/images/menu1.png'),
          ...response.data.map(
            (c) => CategoryItem(
              name: c.name,
              image: (c.image != null && c.image!.isNotEmpty)
                  ? c.image!
                  : 'assets/images/menu1.png',
            ),
          ),
        ];
        categories.assignAll(apiList);
      }
    } catch (e) {
      debugPrint('fetchCategories error: $e');
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  void startOfferTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (offerRemaining.value.inSeconds > 0) {
        offerRemaining.value =
            offerRemaining.value - const Duration(seconds: 1);
      }
    });
  }

  String get formattedOfferTime {
    final duration = offerRemaining.value;

    final hours = duration.inHours.toString().padLeft(2, '0');

    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');

    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  // ==============================
  // HEADER ACTIONS
  // ==============================

  void openNotifications() {
    Get.toNamed(AppRoutes.notifications);
  }

  void openFavorites() {
    debugPrint('Favorite clicked');
  }

  void openProfile() {
    debugPrint('Profile clicked');
  }

  void viewCategories() {
    changeBottomIndex(1);
  }

  void viewAllRestaurants() {
    Get.toNamed(AppRoutes.popularNearYou);
  }

  void onRestaurantTap(RestaurantItem restaurant) {
    Get.toNamed(AppRoutes.category, arguments: restaurant);
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

  CategoryItem({required this.name, required this.image});
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
