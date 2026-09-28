import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/presentation/controller/cart_controller.dart';
import 'package:kayal_userapp/presentation/controller/category_restaurants_controller.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/restaurant_card.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/widgets/restaurant_unavailable_banner.dart';

class CategoryRestaurantsScreen extends StatelessWidget {
  CategoryRestaurantsScreen({super.key});

  final CategoryRestaurantsController controller =
      Get.put(CategoryRestaurantsController());

  @override
  Widget build(BuildContext context) {
    controller.updateArguments(Get.arguments);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      appBar: CustomAppBar(
        title: '${controller.categoryName.value} Restaurants',
        showBackButton: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
                onTap: controller.viewCart,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF823E),
                    shape: BoxShape.circle,
                  ),
                  child: Obx(() {
                    int count = 0;
                    if (Get.isRegistered<CartController>()) {
                      final cartController = Get.find<CartController>();
                      count = cartController.cartItems.fold<int>(
                        0,
                        (sum, item) => sum + item.quantity.value,
                      );
                    }
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          carticon,
                          width: 22,
                          height: 22,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        if (count > 0)
                          Positioned(
                            right: 7,
                            top: 5,
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                height: 1.0,
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFFEBE3),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Color(0xFFFF823E),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: controller.searchController,
                              onChanged: controller.onSearchChanged,
                              decoration: InputDecoration(
                                hintText:
                                    'Search ${controller.categoryName.value} restaurants...',
                                hintStyle: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: const Color(0xFF9E9E9E),
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: controller.openFilter,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFFEBE3),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.tune,
                          color: Color(0xFFFF823E),
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Parent Restaurant Closed Notice
            Obx(
              () => controller.isParentRestaurantClosed.value
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                      child: RestaurantUnavailableBanner(
                        notes: controller.parentClosedNotes.value,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Restaurant Count & Subtitle
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Restaurants',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF252B35),
                      ),
                    ),
                    Text(
                      '${controller.filteredRestaurants.length} found',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFF823E),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // List of Restaurants
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFF823E),
                    ),
                  );
                }

                if (controller.filteredRestaurants.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFEDE3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.storefront_outlined,
                              size: 40,
                              color: Color(0xFFFF823E),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Data',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF252B35),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'No restaurants currently offering ${controller.categoryName.value} were found.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.filteredRestaurants.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final restaurant = controller.filteredRestaurants[index];
                    return GestureDetector(
                      onTap: () => controller.onRestaurantTap(restaurant),
                      child: RestaurantCard(restaurant: restaurant),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
