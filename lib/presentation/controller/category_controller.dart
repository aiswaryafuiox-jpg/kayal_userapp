import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/categories_response_model.dart';
import 'package:kayal_userapp/data/repository/categories_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/get_categories_usecase.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';

class CategoryController extends GetxController {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoryController({GetCategoriesUseCase? getCategoriesUseCase})
      : _getCategoriesUseCase = getCategoriesUseCase ??
            (sl.isRegistered<GetCategoriesUseCase>()
                ? sl<GetCategoriesUseCase>()
                : GetCategoriesUseCase(
                    CategoriesRepositoryImpl(ApiService())));

  final searchController = TextEditingController();

  final searchText = ''.obs;
  final selectedSort = 'Popularity'.obs;
  final selectedDietary = 'Non - Veg'.obs;
  final isRestaurantClosed = false.obs;
  final closedNotes =
      'This restaurant is currently unavailable.\nOpens today 10:00 AM'.obs;
  dynamic restaurantData;

  final RxBool isLoading = false.obs;
  final RxList<CategoryModel> apiCategories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    updateArguments(Get.arguments);
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final response = await _getCategoriesUseCase();
      if (response.success && response.data.isNotEmpty) {
        apiCategories.assignAll(response.data);
        categories.assignAll(
          response.data.map(
            (c) => {
              'name': c.name,
              'image': (c.image != null && c.image!.isNotEmpty)
                  ? c.image!
                  : categoryImg1,
            },
          ),
        );
      } else {
        apiCategories.clear();
        categories.clear();
      }
    } catch (e) {
      debugPrint('fetchCategories error: $e');
      apiCategories.clear();
      categories.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void updateArguments([dynamic args]) {
    final currentArgs = args ?? Get.arguments;
    if (currentArgs != null) {
      restaurantData = currentArgs;
      if (currentArgs is RestaurantItem) {
        isRestaurantClosed.value = !currentArgs.isOpen;
        if (!currentArgs.isOpen) {
          closedNotes.value =
              'This restaurant is currently unavailable.\n${currentArgs.openingTime}';
        }
      } else if (currentArgs is Map) {
        if (currentArgs['isClosed'] != null) {
          isRestaurantClosed.value = currentArgs['isClosed'] == true;
        }
        if (currentArgs['notes'] != null) {
          closedNotes.value = currentArgs['notes'];
        }
        if (currentArgs['restaurant'] != null &&
            currentArgs['restaurant'] is RestaurantItem) {
          final RestaurantItem r = currentArgs['restaurant'];
          isRestaurantClosed.value = !r.isOpen;
          if (!r.isOpen) {
            closedNotes.value =
                'This restaurant is currently unavailable.\n${r.openingTime}';
          }
        }
      }
    }
  }

  final categories = <Map<String, String>>[].obs;

  List<Map<String, String>> get filteredCategories {
    if (searchText.value.trim().isEmpty) {
      return categories;
    }

    return categories
        .where(
          (category) => category['name']!
              .toLowerCase()
              .contains(searchText.value.toLowerCase()),
        )
        .toList();
  }

  void searchCategory(String value) {
    searchText.value = value;
  }

  void setSort(String option) {
    selectedSort.value = option;
  }

  void setDietary(String option) {
    selectedDietary.value = option;
  }

  void resetFilters() {
    selectedSort.value = 'Popularity';
    selectedDietary.value = 'Non - Veg';
  }

  void applyFilters() {
    Get.back();
  }

  Widget _buildFilterOption(String option, String selectedValue, ValueChanged<String> onTap) {
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
                  'Filter',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textprimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
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
            Obx(() => Column(
              children: [
                _buildFilterOption('Popularity', selectedSort.value, (val) => setSort(val)),
                const SizedBox(height: 8),
                _buildFilterOption('Ratings', selectedSort.value, (val) => setSort(val)),
                const SizedBox(height: 8),
                _buildFilterOption('Price : Low --> High', selectedSort.value, (val) => setSort(val)),
                const SizedBox(height: 8),
                _buildFilterOption('Price : High --> Low', selectedSort.value, (val) => setSort(val)),
              ],
            )),
            const SizedBox(height: 20),
            const Text(
              'Dietary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textprimary,
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => Column(
              children: [
                _buildFilterOption('Veg', selectedDietary.value, (val) => setDietary(val)),
                const SizedBox(height: 8),
                _buildFilterOption('Non - Veg', selectedDietary.value, (val) => setDietary(val)),
              ],
            )),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => resetFilters(),
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
                      onPressed: () => applyFilters(),
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

  void selectCategory(String category) {
    debugPrint('Selected category: $category');

    final matched = apiCategories.firstWhereOrNull(
      (c) => c.name.trim().toLowerCase() == category.trim().toLowerCase(),
    );

    if (restaurantData != null) {
      // If already within a restaurant context -> Go directly to Product List screen
      Get.toNamed(
        AppRoutes.product,
        arguments: {
          'category': category,
          'categoryId': matched?.id,
          'restaurantId': restaurantData is RestaurantItem
              ? restaurantData.id
              : (restaurantData is Map ? restaurantData['id'] : null),
          'isClosed': isRestaurantClosed.value,
          'notes': closedNotes.value,
          'restaurant': restaurantData,
        },
      );
    } else {
      // Standalone Category selected from Category Screen -> Go to Category Restaurants Screen
      Get.toNamed(
        AppRoutes.categoryRestaurants,
        arguments: {
          'category': category,
          'categoryId': matched?.id,
          'isClosed': isRestaurantClosed.value,
          'notes': closedNotes.value,
        },
      );
    }
  }

  void goBack() {
    Get.back();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}