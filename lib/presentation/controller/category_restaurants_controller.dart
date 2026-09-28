import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/repository/popular_restaurants_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/popular_restaurants_usecase.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';

class CategoryRestaurantsController extends GetxController {
  final PopularRestaurantsUseCase _popularRestaurantsUseCase;

  CategoryRestaurantsController({PopularRestaurantsUseCase? popularRestaurantsUseCase})
      : _popularRestaurantsUseCase = popularRestaurantsUseCase ??
            (sl.isRegistered<PopularRestaurantsUseCase>()
                ? sl<PopularRestaurantsUseCase>()
                : PopularRestaurantsUseCase(
                    PopularRestaurantsRepositoryImpl(ApiService())));

  final RxString categoryName = 'Category'.obs;
  dynamic categoryId;
  final RxBool isParentRestaurantClosed = false.obs;
  final RxString parentClosedNotes = ''.obs;

  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  final RxList<RestaurantItem> allRestaurants = <RestaurantItem>[].obs;
  final RxString selectedSort = 'Popularity'.obs;
  final RxString selectedDietary = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    updateArguments(Get.arguments);
    fetchRestaurants();
  }

  void updateArguments([dynamic args]) {
    final currentArgs = args ?? Get.arguments;
    if (currentArgs != null) {
      if (currentArgs is Map) {
        if (currentArgs['category'] != null) {
          categoryName.value = currentArgs['category'].toString();
        }
        if (currentArgs['categoryId'] != null) {
          categoryId = currentArgs['categoryId'];
        }
        if (currentArgs['isClosed'] != null) {
          isParentRestaurantClosed.value = currentArgs['isClosed'] == true;
        }
        if (currentArgs['notes'] != null) {
          parentClosedNotes.value = currentArgs['notes'].toString();
        }
      } else if (currentArgs is String) {
        categoryName.value = currentArgs;
      }
    }
  }

  Future<void> fetchRestaurants() async {
    try {
      isLoading.value = true;
      final response = await _popularRestaurantsUseCase();
      if (response.success && response.data.isNotEmpty) {
        final fetched = response.data.map(
          (item) => RestaurantItem(
            name: item.name,
            image: (item.image != null && item.image!.isNotEmpty)
                ? item.image!
                : 'assets/images/homeimg.png',
            cuisine: (item.cuisine != null && item.cuisine!.isNotEmpty)
                ? item.cuisine!
                : '${categoryName.value} Special',
            deliveryTime: item.deliveryTime ?? '25-30 mins',
            distance: item.distance ?? '2.8 Km',
            openingTime: item.openingTime ?? '10:00 Am - 11:00 Pm',
            isOpen: item.isOpen,
          ),
        ).toList();

        allRestaurants.assignAll(fetched);
      } else {
        allRestaurants.clear();
      }
    } catch (e) {
      debugPrint('fetchRestaurants error: $e');
      allRestaurants.clear();
    } finally {
      isLoading.value = false;
    }
  }

  List<RestaurantItem> get filteredRestaurants {
    final query = searchQuery.value.trim().toLowerCase();
    return allRestaurants.where((r) {
      if (query.isEmpty) return true;
      return r.name.toLowerCase().contains(query) ||
          r.cuisine.toLowerCase().contains(query);
    }).toList();
  }

  void onSearchChanged(String val) {
    searchQuery.value = val;
  }

  void onRestaurantTap(RestaurantItem restaurant) {
    Get.toNamed(
      AppRoutes.product,
      arguments: {
        'category': categoryName.value,
        'categoryId': categoryId,
        'restaurant': restaurant,
        'isClosed': !restaurant.isOpen,
        'notes': !restaurant.isOpen
            ? 'This restaurant is currently unavailable.\n${restaurant.openingTime}'
            : null,
      },
    );
  }

  void viewCart() {
    Get.toNamed(AppRoutes.cart);
  }

  void openFilter() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Restaurants',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textprimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.close,
                      color: AppColors.red,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Sort By',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textprimary,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Column(
                children: [
                  _buildFilterOption('Popularity', selectedSort.value, (val) {
                    selectedSort.value = val;
                  }),
                  const SizedBox(height: 8),
                  _buildFilterOption('Ratings', selectedSort.value, (val) {
                    selectedSort.value = val;
                  }),
                  const SizedBox(height: 8),
                  _buildFilterOption('Delivery Time', selectedSort.value, (val) {
                    selectedSort.value = val;
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        selectedSort.value = 'Popularity';
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildFilterOption(
    String option,
    String selectedValue,
    ValueChanged<String> onTap,
  ) {
    final bool isSelected = option == selectedValue;
    return GestureDetector(
      onTap: () => onTap(option),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFFFEBE3),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFFFFB27A).withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.all(2.5),
              child: isSelected
                  ? const DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              option,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textprimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
