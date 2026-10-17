import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/presentation/controller/wishlist_controller.dart';
import 'package:kayal_userapp/presentation/view/wishlist/widgets/wishlist_product_card.dart';
import 'package:kayal_userapp/presentation/widgets/app_embedded_image.dart';

class WishlistScreen extends StatelessWidget {
  final bool? showBackButton;

  const WishlistScreen({super.key, this.showBackButton});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WishlistController>();
    final bool shouldShowBack =
        showBackButton ??
        (Get.arguments is Map
            ? (Get.arguments['showBackButton'] ?? false)
            : (ModalRoute.of(context)?.canPop ?? false));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => controller.fetchWishlist(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: RangeMaintainingScrollPhysics(),
          ),
          slivers: [
            // Top App Bar with background image
            SliverToBoxAdapter(
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(26),
                    bottomRight: Radius.circular(26),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const AppEmbeddedImage(
                        asset: hometopbg,
                        width: double.infinity,
                        height: 210,
                        fit: BoxFit.cover,
                        backgroundColor: AppColors.primary,
                      ),
                      SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (shouldShowBack) ...[
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.06,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.arrow_back_ios_new,
                                        size: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                              ],
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
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.only(top: 2),
                                child: const Text(
                                  'Wishlist',
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
            ),

            // Content: Loading, Empty, or Products Grid
            Obx(() {
              if (controller.isLoading.value &&
                  controller.wishlistItems.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }

              if (controller.wishlistItems.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      "Your wishlist is empty",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom: 100,
                ),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.74,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = controller.wishlistItems[index];
                    return WishlistProductCard(
                      item: item,
                      controller: controller,
                      onFavoriteTap: () => controller.toggleFavorite(index),
                      onAddTap: () => controller.incrementQuantity(item),
                      onRemoveTap: () => controller.decrementQuantity(item),
                    );
                  }, childCount: controller.wishlistItems.length),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
