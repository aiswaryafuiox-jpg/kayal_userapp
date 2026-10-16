import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
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

class HomeController extends GetxController with WidgetsBindingObserver {
  final BannerUseCase _bannerUseCase;
  final PopularRestaurantsUseCase _popularRestaurantsUseCase;
  final OffersUseCase _offersUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  HomeController({
    BannerUseCase? bannerUseCase,
    PopularRestaurantsUseCase? popularRestaurantsUseCase,
    OffersUseCase? offersUseCase,
    GetCategoriesUseCase? getCategoriesUseCase,
  }) : _bannerUseCase =
           bannerUseCase ??
           (sl.isRegistered<BannerUseCase>()
               ? sl<BannerUseCase>()
               : BannerUseCase(BannerRepositoryImpl(ApiService()))),
       _popularRestaurantsUseCase =
           popularRestaurantsUseCase ??
           (sl.isRegistered<PopularRestaurantsUseCase>()
               ? sl<PopularRestaurantsUseCase>()
               : PopularRestaurantsUseCase(
                   PopularRestaurantsRepositoryImpl(ApiService()),
                 )),
       _offersUseCase =
           offersUseCase ??
           (sl.isRegistered<OffersUseCase>()
               ? sl<OffersUseCase>()
               : OffersUseCase(OffersRepositoryImpl(ApiService()))),
       _getCategoriesUseCase =
           getCategoriesUseCase ??
           (sl.isRegistered<GetCategoriesUseCase>()
               ? sl<GetCategoriesUseCase>()
               : GetCategoriesUseCase(CategoriesRepositoryImpl(ApiService())));

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
  final isBottomNavVisible = true.obs;
  final isBottomNavFullyHidden = false.obs;
  final pageController = PageController();

  void hideBottomNav() {
    if (isBottomNavVisible.value) {
      isBottomNavVisible.value = false;
    }
  }

  void showBottomNav() {
    isBottomNavFullyHidden.value = false;
    if (!isBottomNavVisible.value) {
      isBottomNavVisible.value = true;
    }
  }

  Future<void> changeBottomIndex(int index) async {
    showBottomNav();
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
  StreamSubscription<ServiceStatus>? _locationServiceSubscription;
  bool _locationDialogVisible = false;

  final userName = 'Guest'.obs;
  final userLocation = 'Chennai, Tamil Nadu'.obs;
  final isLocationEnabled = true.obs;
  final isLocationLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadUserInfo();
    startOfferTimer();
    fetchBanners();
    fetchPopularRestaurants();
    fetchOffers();
    fetchCategories();
    _listenToLocationService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndLoadCurrentLocation(showDialogWhenDisabled: true);
    });

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

  void _listenToLocationService() {
    _locationServiceSubscription?.cancel();
    _locationServiceSubscription = Geolocator.getServiceStatusStream().listen(
      (status) {
        final enabled = status == ServiceStatus.enabled;
        isLocationEnabled.value = enabled;
        if (enabled) {
          checkAndLoadCurrentLocation(showDialogWhenDisabled: false);
        } else {
          userLocation.value = 'Please enable location';
          showEnableLocationDialog();
        }
      },
      onError: (Object error) {
        debugPrint('Location service stream error: $error');
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkAndLoadCurrentLocation(showDialogWhenDisabled: false);
    }
  }

  Future<void> checkAndLoadCurrentLocation({
    bool showDialogWhenDisabled = false,
  }) async {
    if (isLocationLoading.value) return;

    try {
      isLocationLoading.value = true;
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      isLocationEnabled.value = serviceEnabled;

      if (!serviceEnabled) {
        userLocation.value = 'Please enable location';
        if (showDialogWhenDisabled) showEnableLocationDialog();
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        isLocationEnabled.value = false;
        userLocation.value = 'Please enable location permission';
        if (showDialogWhenDisabled) {
          showEnableLocationDialog(permissionDenied: true);
        }
        return;
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 12),
          ),
        );
      } catch (_) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) return;

      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final parts =
              <String?>[
                    place.locality,
                    place.subAdministrativeArea,
                    place.administrativeArea,
                  ]
                  .whereType<String>()
                  .map((value) => value.trim())
                  .where((value) => value.isNotEmpty)
                  .toSet()
                  .take(2)
                  .toList();
          if (parts.isNotEmpty) {
            userLocation.value = parts.join(', ').capitalizeWords();
            return;
          }
        }
      } catch (error) {
        debugPrint('Reverse geocoding error: $error');
      }

      userLocation.value =
          '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
    } catch (error) {
      debugPrint('Home location error: $error');
    } finally {
      isLocationLoading.value = false;
    }
  }

  Future<void> enableLocation() async {
    if (_locationDialogVisible && Get.isDialogOpen == true) {
      Get.back<void>();
    }
    _locationDialogVisible = false;

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    } else if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
    } else {
      await checkAndLoadCurrentLocation(showDialogWhenDisabled: false);
    }
  }

  void showEnableLocationDialog({bool permissionDenied = false}) {
    if (_locationDialogVisible || Get.context == null) return;
    _locationDialogVisible = true;

    Get.dialog<void>(
      Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primary,
                  size: 31,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enable Location',
                style: TextStyle(
                  color: AppColors.textprimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                permissionDenied
                    ? 'Allow location permission in Settings to show your current location and nearby restaurants.'
                    : 'Turn on location services to show your current location and nearby restaurants.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: enableLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Enable Location',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Get.back<void>(),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textprimary,
                ),
                child: const Text('Not Now'),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    ).whenComplete(() => _locationDialogVisible = false);
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
      if (city != null &&
          city.isNotEmpty &&
          state != null &&
          state.isNotEmpty) {
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
        final fetched = response.data
            .map(
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
                rating: item.rating ?? '4.2',
              ),
            )
            .toList();
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
    _locationServiceSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
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
    changeBottomIndex(4);
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

    if (selectedCategory.value >= 0 &&
        selectedCategory.value < categories.length) {
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
        'categoryId': ?selectedCatId,
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
  final dynamic rating;

  RestaurantItem({
    this.id,
    required this.name,
    required this.image,
    required this.cuisine,
    required this.deliveryTime,
    required this.distance,
    required this.openingTime,
    required this.isOpen,
    this.rating = '4.2',
  });
}
