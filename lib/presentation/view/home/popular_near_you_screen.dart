import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayal_userapp/presentation/controller/popular_near_you_controller.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/restaurant_card.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';

class PopularNearYouScreen extends StatelessWidget {
  PopularNearYouScreen({super.key});

  final PopularNearYouController controller =
      Get.put(PopularNearYouController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      appBar: const CustomAppBar(
        title: 'Popular Near You',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Obx(
                () => Text(
                  controller.radiusText.value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF823E),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  itemCount: controller.restaurants.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final restaurant = controller.restaurants[index];
                    return GestureDetector(
                      onTap: () => controller.onRestaurantTap(restaurant),
                      child: RestaurantCard(restaurant: restaurant),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
