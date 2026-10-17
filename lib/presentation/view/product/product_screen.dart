import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/presentation/controller/product_controller.dart';
import 'package:kayal_userapp/presentation/view/product/widgets/product_card.dart';
import 'package:kayal_userapp/presentation/view/product/widgets/product_filter_section.dart';
import 'package:kayal_userapp/presentation/view/product/widgets/restaurant_details_card.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/widgets/restaurant_unavailable_banner.dart';
import 'package:kayal_userapp/presentation/widgets/view_cart_bottom_bar.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final ProductController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controller.updateArguments(Get.arguments);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Obx(
          () =>
              CustomAppBar(title: controller.title.value, showBackButton: true),
        ),
      ),
      bottomNavigationBar: const ViewCartBottomBar(),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFFF823E),
          onRefresh: controller.refreshProducts,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // Restaurant Details Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Obx(() {
                    final restaurant = controller.restaurantItem.value;
                    if (restaurant == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: RestaurantDetailsCard(
                        restaurant: restaurant,
                        isClosed: controller.isRestaurantClosed.value,
                      ),
                    );
                  }),
                ),
              ),

              // Restaurant Unavailable Banner (if closed)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Obx(
                    () => controller.isRestaurantClosed.value
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: RestaurantUnavailableBanner(
                              notes: controller.closedNotes.value,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),

              // Filter Section (Search, Quick Filter Chips & Count)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 12),
                  child: ProductFilterSection(controller: controller),
                ),
              ),

              // Products Content (Loading, Empty state, or Grid)
              Obx(() {
                if (controller.isLoading.value && controller.products.isEmpty) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF823E),
                      ),
                    ),
                  );
                }

                final items = controller.filteredProducts;

                if (items.isEmpty) {
                  final bool isFilterEmpty =
                      controller.products.isNotEmpty &&
                      controller.hasActiveFilters;

                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFECE0),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isFilterEmpty
                                    ? Icons.filter_alt_off_outlined
                                    : Icons.fastfood_outlined,
                                size: 36,
                                color: const Color(0xFFFF823E),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              isFilterEmpty ? 'No Matching Dishes' : 'No Data',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF252B35),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isFilterEmpty
                                  ? 'No dishes match your selected filter criteria.'
                                  : 'No products found',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: const Color(0xFF6B7280),
                              ),
                            ),
                            if (isFilterEmpty) ...[
                              const SizedBox(height: 16),
                              TextButton.icon(
                                onPressed: controller.resetFilters,
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  size: 18,
                                  color: Color(0xFFFF823E),
                                ),
                                label: Text(
                                  'Clear All Filters',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFFFF823E),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.70,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ProductCard(
                        product: items[index],
                        controller: controller,
                        isRestaurantClosed: controller.isRestaurantClosed.value,
                      );
                    }, childCount: items.length),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
