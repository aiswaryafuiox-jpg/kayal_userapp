import 'package:flutter/material.dart';
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

  final HomeController controller =
      Get.put(HomeController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),

      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    const HomeHeader(),

                    // SEARCH
                    const SearchBarWidget(),

                    const SizedBox(height: 20),

                    // BANNER
                    const PromotionCarousel(),

                    const SizedBox(height: 18),

                    // FOOD MENU TITLE
                    SectionTitle(
                      title: 'Food Menu',
                      onTap: controller.viewAllRestaurants,
                    ),

                    const SizedBox(height: 10),

                    // CATEGORIES
                    const CategoryList(),

                    const SizedBox(height: 22),

                    // POPULAR
                    SectionTitle(
                      title: 'Popular Near you',
                      onTap: controller.viewAllRestaurants,
                    ),

                    const SizedBox(height: 10),

                    // RESTAURANTS
                    Obx(
                      () => ListView.separated(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        itemCount:
                            controller.restaurants.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          return RestaurantCard(
                            restaurant:
                                controller.restaurants[index],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 22),

                    // MY OFFER
                    SectionTitle(
                      title: 'My Offer',
                      onTap: controller.viewOffers,
                    ),

                    const SizedBox(height: 8),

                    const OfferTimer(),

                    const SizedBox(height: 10),

                    // OFFER RESTAURANT
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: Obx(
                        () => RestaurantCard(
                          restaurant:
                              controller.restaurants.first,
                        ),
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // BOTTOM NAVIGATION
            const BottomNavBar(),
          ],
        ),
      ),
    );
  }
}