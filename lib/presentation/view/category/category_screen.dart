import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/presentation/controller/category_controller.dart';
import 'package:kayal_userapp/presentation/view/category/widgets/category_grid.dart';
import 'package:kayal_userapp/presentation/view/category/widgets/category_searchbar.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/widgets/restaurant_unavailable_banner.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    controller.updateArguments(Get.arguments);
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      body: SafeArea(
        child: Column(
          children: [
            // ================================
            // APP BAR
            // ================================
            CustomAppBar(
              title: 'Category',
              showBackButton: Navigator.canPop(context),
            ),

            // ================================
            // SEARCH
            // ================================
            CategorySearchBar(
              controller: controller,
            ),

            // ================================
            // UNAVAILABLE NOTICE BANNER
            // ================================
            Obx(
              () => controller.isRestaurantClosed.value
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                      child: RestaurantUnavailableBanner(
                        notes: controller.closedNotes.value,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 16),

            // ================================
            // CATEGORY GRID
            // ================================
            Expanded(
              child: Obx(
                () => CategoryGrid(
                  categories: controller.filteredCategories,
                  isClosed: controller.isRestaurantClosed.value,
                  onCategoryTap: controller.selectCategory,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}