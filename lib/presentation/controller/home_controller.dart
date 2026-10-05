import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/banner_response_model.dart';
import 'package:kayal_userapp/presentation/controller/cart_controller.dart';
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

  final List<String> banners = [];

  // ==============================
  // CATEGORIES
  // ==============================

  final selectedCategory = 0.obs;
  final RxBool isCategoriesLoading = false.obs;

  final RxList<CategoryItem> categories = <CategoryItem>[].obs;

  void selectCategory(int index) {
    selectedCategory.value = index;
    if (index >= 0 && index < categories.length) {
      final categoryItem = categories[index];
      final catName = categoryItem.name.trim().toLowerCase();

      if (catName == 'all' || categoryItem.id == null) {
        fetchPopularRestaurants();
      } else {
        fetchPopularRestaurants(categoryId: categoryItem.id);
      }
    } else {
      fetchPopularRestaurants();
    }
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

  final RxList<RestaurantItem> allRestaurants = <RestaurantItem>[].obs;
  final RxList<RestaurantItem> restaurants = <RestaurantItem>[].obs;
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

  final userName = 'Guest'.obs;
  final userLocation = 'Chennai, Tamil Nadu'.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
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

  void loadUserInfo() {
    final storage = LocalStorageService();
    final bool loggedIn = storage.isLoggedIn();

    if (loggedIn) {
      final name = storage.getFullName();
      if (name != null && name.trim().isNotEmpty) {
        userName.value = name.trim().capitalizeWords();
      } else {
        userName.value = 'User';
      }

      final city = storage.getCity();
      final state = storage.getString(LocalStorageService.keyState);
      final address = storage.getAddress();
      if (city != null && city.isNotEmpty && state != null && state.isNotEmpty) {
        userLocation.value = '$city, $state'.capitalizeWords();
      } else if (city != null && city.isNotEmpty) {
        userLocation.value = city.capitalizeWords();
      } else if (address != null && address.isNotEmpty) {
        userLocation.value = address.capitalizeWords();
      } else {
        userLocation.value = 'Chennai, Tamil Nadu';
      }
    } else {
      userName.value = 'Guest';
      userLocation.value = 'Chennai, Tamil Nadu';
    }
  }

  Future<void> refreshHome() async {
    loadUserInfo();
    if (Get.isRegistered<CartController>()) {
      Get.find<CartController>().fetchCart(showLoading: false);
    }
    await Future.wait([
      fetchBanners(),
      fetchPopularRestaurants(),
      fetchOffers(),
      fetchCategories(),
    ]);
  }

  Future<void> fetchBanners() async {
    try {
      isBannersLoading.value = true;
      final response = await _bannerUseCase();
      if (response.success && response.data.isNotEmpty) {
        apiBanners.assignAll(response.data);
      } else {
        apiBanners.clear();
      }
    } catch (e) {
      debugPrint('fetchBanners error: $e');
      apiBanners.clear();
    } finally {
      isBannersLoading.value = false;
    }
  }

  Future<void> fetchPopularRestaurants({
    dynamic categoryId,
    double? lat,
    double? lng,
  }) async {
    try {
      isRestaurantsLoading.value = true;
      final response = await _popularRestaurantsUseCase(
        categoryId: categoryId,
        lat: lat,
        lng: lng,
      );
      if (response.success && response.data.isNotEmpty) {
        final fetched = response.data.map(
          (item) => RestaurantItem(
            id: item.id,
            name: item.name.capitalizeWords(),
            image: (item.image != null && item.image!.isNotEmpty)
                ? item.image!
                : 'assets/images/homeimg.png',
            cuisine: (item.cuisine != null && item.cuisine!.isNotEmpty)
                ? item.cuisine!.capitalizeWords()
                : 'Special Dishes',
            deliveryTime: item.deliveryTime ?? '25-30 mins',
            distance: item.distance ?? '2.8 Km',
            openingTime: item.openingTime ?? '10:00 Am - 11:00 Pm',
            isOpen: item.isOpen,
          ),
        ).toList();
        restaurants.assignAll(fetched);
        if (categoryId == null) {
          allRestaurants.assignAll(fetched);
        }
      } else {
        restaurants.clear();
        if (categoryId == null) {
          allRestaurants.clear();
        }
      }
    } catch (e) {
      debugPrint('fetchPopularRestaurants error: $e');
      restaurants.clear();
      if (categoryId == null) {
        allRestaurants.clear();
      }
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
      } else {
        apiOffers.clear();
      }
    } catch (e) {
      debugPrint('fetchOffers error: $e');
      apiOffers.clear();
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
              id: c.id,
              name: c.name.capitalizeWords(),
              image: (c.image != null && c.image!.isNotEmpty)
                  ? c.image!
                  : 'assets/images/menu1.png',
            ),
          ),
        ];
        categories.assignAll(apiList);
      } else {
        categories.clear();
      }
    } catch (e) {
      debugPrint('fetchCategories error: $e');
      categories.clear();
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

  void openCart() {
    Get.toNamed(AppRoutes.cart);
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
    dynamic selectedCatId;
    String? selectedCatName;

    if (selectedCategory.value >= 0 && selectedCategory.value < categories.length) {
      final item = categories[selectedCategory.value];
      if (item.name.toLowerCase() != 'all') {
        selectedCatId = item.id;
        selectedCatName = item.name;
      }
    }

    Get.toNamed(
      AppRoutes.product,
      arguments: {
        'restaurant': restaurant,
        'restaurantId': restaurant.id,
        'category': selectedCatName ?? restaurant.name,
        'categoryId': selectedCatId ?? 1,
        'isClosed': !restaurant.isOpen,
        'notes': !restaurant.isOpen
            ? 'This restaurant is currently unavailable.\n${restaurant.openingTime}'
            : null,
      },
    );
  }

  void viewOffers() {
    debugPrint('View all offers');
  }
}

// =======================================
// CATEGORY MODEL
// =======================================

class CategoryItem {
  final dynamic id;
  final String name;
  final String image;

  CategoryItem({this.id, required this.name, required this.image});
}

// =======================================
// RESTAURANT MODEL
// =======================================

class RestaurantItem {
  final dynamic id;
  final String name;
  final String image;
  final String cuisine;
  final String deliveryTime;
  final String distance;
  final String openingTime;
  final bool isOpen;

  RestaurantItem({
    this.id,
    required this.name,
    required this.image,
    required this.cuisine,
    required this.deliveryTime,
    required this.distance,
    required this.openingTime,
    required this.isOpen,
  });
}
