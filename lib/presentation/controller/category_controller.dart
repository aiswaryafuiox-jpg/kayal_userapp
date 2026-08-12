import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';

class CategoryController extends GetxController {
  final searchController = TextEditingController();

  final searchText = ''.obs;

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
    Get.toNamed('/product');
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