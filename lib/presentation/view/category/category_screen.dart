import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/presentation/controller/category_controller.dart';
import 'package:kayal_userapp/presentation/view/category/widgets/category_grid.dart';
import 'package:kayal_userapp/presentation/view/category/widgets/category_searchbar.dart';
import 'package:kayal_userapp/presentation/widgets/app_embedded_image.dart';
import 'package:kayal_userapp/presentation/widgets/restaurant_unavailable_banner.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});

  final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    controller.updateArguments(Get.arguments);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      body: RefreshIndicator(
        onRefresh: controller.fetchCategories,
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(
            parent: RangeMaintainingScrollPhysics(),
          ),
          slivers: [
            // APP BAR + SEARCH BAR
            SliverToBoxAdapter(
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: 140,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(26),
                        bottomRight: Radius.circular(26),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        clipBehavior: .none,
                        children: [
                          const AppEmbeddedImage(
                            asset: hometopbg,
                            width: double.infinity,
                            height: 210,
                            fit: BoxFit.cover,
                            backgroundColor: AppColors.primary,
                          ),
                          Positioned(
                            left: 24,
                            top: 10,
                            child: SafeArea(
                              bottom: false,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withValues(
                                            alpha: 0.32,
                                          ),
                                          blurRadius: 16,
                                          spreadRadius: 4,
                                          offset: const Offset(
                                            0,
                                            4,
                                          ), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      'Category',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    left: 24,
                    right: 24,
                    child: CategorySearchBar(controller: controller),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 60)),
            // UNAVAILABLE NOTICE
            SliverToBoxAdapter(
              child: Obx(
                () => controller.isRestaurantClosed.value
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                        child: RestaurantUnavailableBanner(
                          notes: controller.closedNotes.value,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),

            // CATEGORY GRID
            Obx(() {
              if (controller.isLoading.value && controller.categories.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF823E)),
                  ),
                );
              }

              return CategoryGrid(
                categories: controller.filteredCategories,
                isClosed: controller.isRestaurantClosed.value,
                onCategoryTap: controller.selectCategory,
              );
            }),

            // BOTTOM PADDING
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
