import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/presentation/controller/wishlist_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/view/wishlist/widgets/wishlist_product_card.dart';

class WishlistScreen extends StatelessWidget {
  final bool? showBackButton;

  const WishlistScreen({super.key, this.showBackButton});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WishlistController());
    final bool shouldShowBack = showBackButton ??
        (Get.arguments is Map
            ? (Get.arguments['showBackButton'] ?? false)
            : false);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Wishlist',
        showBackButton: shouldShowBack,
      ),
      body: Obx(() {
        if (controller.wishlistItems.isEmpty) {
          return const Center(child: Text("Your wishlist is empty"));
        }
        return GridView.builder(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: 100,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.74,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.wishlistItems.length,
          itemBuilder: (context, index) {
            final item = controller.wishlistItems[index];
            return WishlistProductCard(
              item: item,
              onFavoriteTap: () => controller.toggleFavorite(index),
              onAddTap: () {
                // Handle add to cart functionality
              },
            );
          },
        );
      }),
    );
  }
}
