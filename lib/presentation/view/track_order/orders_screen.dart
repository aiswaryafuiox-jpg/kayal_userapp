import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/presentation/controller/orders_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/view/track_order/widgets/order_card.dart';

class OrdersScreen extends StatelessWidget {
  final bool? showBackButton;

  const OrdersScreen({super.key, this.showBackButton});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrdersController());
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
        if (controller.ordersList.isEmpty) {
          return const Center(child: Text("You have no orders"));
        }
        return ListView.separated(
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
      }),
    );
  }
}
