import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/presentation/controller/category_controller.dart';
import 'package:kayal_userapp/presentation/view/category/widgets/category_grid.dart';
import 'package:kayal_userapp/presentation/view/category/widgets/category_searchbar.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/bottom_navbar.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';


class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  final CategoryController controller =
      Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),

      body: SafeArea(
        child: Column(
          children: [

            // ================================
            // APP BAR
            // ================================

            CustomAppBar(title: 'Category', showBackButton: false),

            // ================================
            // SEARCH
            // ================================

            CategorySearchBar(
              controller: controller,
            ),

            const SizedBox(height: 20),

            // ================================
            // CATEGORY GRID
            // ================================

            Expanded(
              child: Obx(
                () => CategoryGrid(
                  categories:
                      controller.filteredCategories,
                  onCategoryTap:
                      controller.selectCategory,
                ),
              ),
            ),
          ],
        ),
      ),

      // ================================
      // BOTTOM NAVIGATION
      // ================================

      bottomNavigationBar: const BottomNavBar(),
    );
  }
}