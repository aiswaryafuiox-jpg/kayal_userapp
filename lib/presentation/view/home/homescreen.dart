import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:kayal_userapp/presentation/controller/home_controller.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/bottom_navbar.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/home_dashboard.dart';
import 'package:kayal_userapp/presentation/view/category/category_screen.dart';
import 'package:kayal_userapp/presentation/view/wishlist/wishlist_screen.dart';
import 'package:kayal_userapp/presentation/view/track_order/orders_screen.dart';
import 'package:kayal_userapp/presentation/view/profile/profile_screen.dart';

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
        body: PageView(
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
        bottomNavigationBar: Obx(
          () => BottomNavBar(
            currentIndex: controller.selectedBottomIndex.value,
            onTap: controller.changeBottomIndex,
          ),
        ),
      ),
    );
  }
}
