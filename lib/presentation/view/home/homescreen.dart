import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:kayal_userapp/presentation/controller/home_controller.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/bottom_navbar.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/home_dashboard.dart';
import 'package:kayal_userapp/presentation/view/category/category_screen.dart';
import 'package:kayal_userapp/presentation/view/wishlist/wishlist_screen.dart';
import 'package:kayal_userapp/presentation/view/track_order/orders_screen.dart';
import 'package:kayal_userapp/presentation/view/profile/profile_screen.dart';
import 'package:kayal_userapp/presentation/widgets/view_cart_bottom_bar.dart';

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
        body: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis == Axis.vertical) {
              if (notification.metrics.pixels <= 0) {
                controller.showBottomNav();
                return false;
              }

              if (notification is UserScrollNotification) {
                if (notification.direction == ScrollDirection.reverse) {
                  controller.hideBottomNav();
                } else if (notification.direction == ScrollDirection.forward) {
                  controller.showBottomNav();
                }
              } else if (notification is ScrollUpdateNotification) {
                final delta = notification.scrollDelta ?? 0;
                if (delta > 2) {
                  controller.hideBottomNav();
                } else if (delta < -2) {
                  controller.showBottomNav();
                }
              }
            }
            return false;
          },
          child: PageView(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const HomeDashboardWidget(),
              CategoryScreen(),
              const WishlistScreen(showBackButton: false),
              const OrdersScreen(),
              const ProfileScreen(),
            ],
          ),
        ),
        floatingActionButton: Obx(() {
          final isVisible = controller.isBottomNavVisible.value;
          final isFullyHidden = controller.isBottomNavFullyHidden.value;

          return Offstage(
            offstage: !isVisible && isFullyHidden,
            child: AnimatedSlide(
              offset: isVisible ? Offset.zero : const Offset(0, 3.0),
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeInOutCubic,
              child: AnimatedOpacity(
                opacity: isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: !isVisible,
                  child: const ViewCartBottomBar(isFloating: true),
                ),
              ),
            ),
          );
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: Obx(() {
          final isVisible = controller.isBottomNavVisible.value;
          final isFullyHidden = controller.isBottomNavFullyHidden.value;

          return Offstage(
            offstage: !isVisible && isFullyHidden,
            child: ClipRect(
              child: AnimatedSlide(
                offset: isVisible ? Offset.zero : const Offset(0, 2.0),
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOutCubic,
                onEnd: () {
                  if (!controller.isBottomNavVisible.value) {
                    controller.isBottomNavFullyHidden.value = true;
                  }
                },
                child: AnimatedOpacity(
                  opacity: isVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: IgnorePointer(
                    ignoring: !isVisible,
                    child: BottomNavBar(
                      currentIndex: controller.selectedBottomIndex.value,
                      onTap: controller.changeBottomIndex,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
