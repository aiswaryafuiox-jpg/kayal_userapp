import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/presentation/controller/orders_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/view/track_order/widgets/order_card.dart';

class OrdersScreen extends StatelessWidget {
  final bool? showBackButton;

  const OrdersScreen({super.key, this.showBackButton});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());
    controller.checkLoginStatus();
    final bool shouldShowBack = showBackButton ??
        (Get.arguments is Map
            ? (Get.arguments['showBackButton'] ?? false)
            : false);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'My Orders',
        showBackButton: shouldShowBack,
      ),
      body: Obx(() {
        final Widget content = controller.ordersList.isEmpty
            ? const Center(child: Text("You have no orders"))
            : ListView.separated(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom: 100,
                ),
                itemCount: controller.ordersList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final order = controller.ordersList[index];
                  return OrderCard(
                    order: order,
                    onViewTap: () => controller.viewOrderDetails(index),
                    onReorderTap: () => controller.reOrder(index),
                  );
                },
              );

        if (!controller.isLoggedIn.value) {
          return Stack(
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                child: content,
              ),
              Container(color: Colors.black.withOpacity(0.12)),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 28),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
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
                              fontWeight: FontWeight.w600,
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

        return content;
      }),
    );
  }
}
