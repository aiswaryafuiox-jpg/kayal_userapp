import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';
import 'package:kayal_userapp/presentation/controller/user_search_controller.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/banner_slider.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/category_list.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/home_header.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/home_search_results.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/restaurant_card.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/section_title.dart';
import 'package:kayal_userapp/presentation/widgets/search_bar_widget.dart';

class HomeDashboardWidget extends StatelessWidget {
  const HomeDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final UserSearchController searchController =
        Get.isRegistered<UserSearchController>()
        ? Get.find<UserSearchController>()
        : Get.put(UserSearchController());

    return SafeArea(
      top: false,
      bottom: false,
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () {
          final query = searchController.query.value.trim();
          return query.isNotEmpty
              ? searchController.performSearch(query)
              : controller.refreshHome();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const HomeHeader(),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -13,
                    child: SearchBarWidget(
                      controller: searchController.searchInputController,
                      onChanged: searchController.onQueryChanged,
                      onSubmitted: searchController.performSearch,
                      hintText: 'Search products or restaurants',
                    ),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 34)),
            Obx(() {
              if (searchController.query.value.trim().isNotEmpty) {
                return SliverToBoxAdapter(
                  child: HomeSearchResults(
                    searchController: searchController,
                    homeController: controller,
                  ),
                );
              }

              return SliverMainAxisGroup(
                slivers: [
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: PromotionCarousel(),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 18)),
                  const SliverToBoxAdapter(
                    child: SectionTitle(title: 'Food Menu'),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  const SliverToBoxAdapter(child: CategoryList()),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverToBoxAdapter(
                    child: SectionTitle(
                      title: 'Popular Near You',
                      onTap: controller.viewAllRestaurants,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  _restaurantList(controller),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  const SliverToBoxAdapter(
                    child: SectionTitle(title: 'Near Me'),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 14)),
                  _nearestRestaurant(controller),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _restaurantList(HomeController controller) {
    return Obx(() {
      if (controller.isRestaurantsLoading.value &&
          controller.restaurants.isEmpty) {
        return const SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(color: Color(0xFFFF823E)),
            ),
          ),
        );
      }

      if (controller.restaurants.isEmpty) {
        return const SliverToBoxAdapter(child: _NoData(verticalPadding: 24));
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final restaurant = controller.restaurants[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == controller.restaurants.length - 1 ? 0 : 14,
              ),
              child: RepaintBoundary(
                child: GestureDetector(
                  onTap: () => controller.onRestaurantTap(restaurant),
                  child: RestaurantCard(restaurant: restaurant),
                ),
              ),
            );
          }, childCount: controller.restaurants.length),
        ),
      );
    });
  }

  Widget _nearestRestaurant(HomeController controller) {
    return Obx(() {
      if (controller.isRestaurantsLoading.value &&
          controller.restaurants.isEmpty) {
        return const SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CircularProgressIndicator(color: Color(0xFFFF823E)),
            ),
          ),
        );
      }

      if (controller.restaurants.isEmpty) {
        return const SliverToBoxAdapter(child: _NoData(verticalPadding: 16));
      }

      final restaurant = controller.restaurants.firstWhere(
        (r) => r.isOpen,
        orElse: () => controller.restaurants.first,
      );
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: RepaintBoundary(
            child: GestureDetector(
              onTap: () => controller.onRestaurantTap(restaurant),
              child: RestaurantCard(restaurant: restaurant),
            ),
          ),
        ),
      );
    });
  }
}

class _NoData extends StatelessWidget {
  final double verticalPadding;

  const _NoData({required this.verticalPadding});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: const Text(
          'No Data',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}
