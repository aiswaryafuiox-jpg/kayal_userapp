import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/presentation/controller/orders_controller.dart';
import 'package:kayal_userapp/presentation/view/track_order/widgets/order_card.dart';
import 'package:kayal_userapp/presentation/widgets/app_embedded_image.dart';

class OrdersScreen extends StatelessWidget {
  final bool? showBackButton;

  const OrdersScreen({super.key, this.showBackButton});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());
    controller.checkLoginStatus();
    final bool shouldShowBack =
        showBackButton ??
        (Get.arguments is Map
            ? (Get.arguments['showBackButton'] ?? false)
            : false);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        Widget contentSliver;

        if (controller.isLoading.value && controller.ordersList.isEmpty) {
          contentSliver = const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        } else if (controller.errorMessage.value.isNotEmpty &&
            controller.ordersList.isEmpty) {
          contentSliver = SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => controller.fetchOrders(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (controller.ordersList.isEmpty) {
          contentSliver = const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 56,
                    color: Color(0xFFD1D5DB),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "You have no orders yet",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          contentSliver = SliverPadding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: 100,
            ),
            sliver: SliverList.separated(
              itemCount: controller.ordersList.length,
              itemBuilder: (context, index) {
                final order = controller.ordersList[index];
                return OrderCard(
                  order: order,
                  onViewTap: () => controller.viewOrderDetails(order),
                  onReorderTap: () => controller.reOrder(order),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            ),
          );
        }

        final Widget scrollView = RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => controller.fetchOrders(isRefresh: true),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: RangeMaintainingScrollPhysics(),
            ),
            slivers: [
              // Top App Bar with hometopbg
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
                                    'My Orders',
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

              contentSliver,
            ],
          ),
        );

        if (!controller.isLoggedIn.value) {
          return Stack(
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                child: scrollView,
              ),
              Container(color: Colors.black.withValues(alpha: 0.12)),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 28),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Log in to check out your orders, view saved addresses, and manage your account details.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textprimary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(
                              AppRoutes.login,
                              arguments: {'redirect': AppRoutes.home, 'tab': 3},
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Log in / Sign up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return scrollView;
      }),
    );
  }
}
