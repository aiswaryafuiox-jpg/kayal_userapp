import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';

class CategoryController extends GetxController {
  final searchController = TextEditingController();

  final searchText = ''.obs;
  final isRestaurantClosed = false.obs;
  final closedNotes =
      'This restaurant is currently unavailable.\nOpens today 10:00 AM'.obs;
  dynamic restaurantData;

  @override
  void onInit() {
    super.onInit();
    updateArguments(Get.arguments);
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

  final categories = <Map<String, String>>[
    {
      'name': 'Pizza',
      'image': categoryImg1,
    },
    {
      'name': 'Burgers',
      'image': categoryImg2,
    },
    {
      'name': 'Desserts',
      'image': categoryImg3,
    },
    {
      'name': 'Chinese',
      'image':categoryImg4,
    },
    {
      'name': 'Biriyani',
      'image':categoryImg5,
    },
    {
      'name': 'Beverages',
      'image': categoryImg6,
    },
    {
      'name': 'Desserts',
      'image': categoryImg3,
    },
    {
      'name': 'Chinese',
      'image': categoryImg4,
    },
  ];

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

  void openFilter() {
    Get.snackbar(
      'Filter',
      'Filter clicked',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void selectCategory(String category) {
    debugPrint('Selected category: $category');

    // Navigate to product listing
    Get.toNamed(
      AppRoutes.product,
      arguments: {
        'category': category,
        'isClosed': isRestaurantClosed.value,
        'notes': closedNotes.value,
        'restaurant': restaurantData,
      },
    );
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