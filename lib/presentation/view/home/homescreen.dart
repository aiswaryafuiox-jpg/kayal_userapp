import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:kayal_userapp/presentation/controller/home_controller.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/bottom_navbar.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/home_header.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/banner_slider.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/section_title.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/category_list.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/restaurant_card.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/offer_timer.dart';
import 'package:kayal_userapp/presentation/widgets/search_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFCFA),
        extendBody: true,
        bottomNavigationBar: const SafeArea(top: false, child: BottomNavBar()),
        body: SafeArea(
          top: false,
          bottom: false,
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            cacheExtent: 500,
            slivers: [
              const SliverToBoxAdapter(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    HomeHeader(),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: -13,
                      child: SearchBarWidget(),
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 34)),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: PromotionCarousel(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 18)),
              SliverToBoxAdapter(
                child: SectionTitle(
                  title: 'Food Menu',
                  onTap: controller.viewAllRestaurants,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 9)),
              const SliverToBoxAdapter(child: CategoryList()),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: SectionTitle(
                  title: 'Popular Near you',
                  onTap: controller.viewAllRestaurants,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index == controller.restaurants.length - 1
                            ? 0
                            : 14,
                      ),
                      child: RepaintBoundary(
                        child: RestaurantCard(
                          restaurant: controller.restaurants[index],
                        ),
                      ),
                    ),
                    childCount: controller.restaurants.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverToBoxAdapter(
                child: SectionTitle(
                  title: 'My Offer',
                  onTap: controller.viewOffers,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 7)),
              const SliverToBoxAdapter(child: OfferTimer()),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: RepaintBoundary(
                    child: RestaurantCard(
                      restaurant: controller.restaurants.first,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 92)),
            ],
          ),
        ),
      ),
    );
  }
}
