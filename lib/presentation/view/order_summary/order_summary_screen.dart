import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/order_summary_response_model.dart';
import 'package:kayal_userapp/presentation/controller/order_summary_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/widgets/custom_buttom.dart';

class OrderSummaryScreen extends StatelessWidget {
  OrderSummaryScreen({super.key});

  final OrderSummaryController controller = Get.put(OrderSummaryController());

  @override
  Widget build(BuildContext context) {
    controller.updateArguments(Get.arguments);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      appBar: const CustomAppBar(
        title: 'Order Summary',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.items.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF823E),
              ),
            );
          }

          if (controller.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFECE0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 48,
                        color: Color(0xFFFF823E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your order is empty',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF252B35),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add dishes to your cart or select an item from the menu to proceed with your order.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),
                    CustomButton(
                      text: 'Explore Menu',
                      onPressed: () => Get.offAllNamed(AppRoutes.home),
                      height: 50,
                      width: 200,
                      backgroundColor: const Color(0xFFFF823E),
                      borderRadius: 14,
                    ),
                  ],
                ),
              ),
            );
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => controller.fetchOrderSummary(),
                color: const Color(0xFFFF823E),
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Items List
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = controller.items[index];
                          return _buildOrderItem(item);
                        },
                      ),
                      const SizedBox(height: 24),

                      // Add Special Instructions
                      GestureDetector(
                        onTap: controller.addSpecialInstructions,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF3F4F6)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.article_outlined,
                                color: Color(0xFF6B7280),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.specialInstructions.value.isNotEmpty
                                      ? 'Instructions: ${controller.specialInstructions.value}'
                                      : 'Add Special instructions',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: controller
                                            .specialInstructions.value.isNotEmpty
                                        ? const Color(0xFFFF823E)
                                        : const Color(0xFF252B35),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Color(0xFF9E9E9E),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Total Amount Box
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Amount',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF252B35),
                                  ),
                                ),
                                Text(
                                  '₹${controller.totalAmount.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFFF823E),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Items Breakdown
                            for (var item in controller.items) ...[
                              _buildBillRow(
                                item.name,
                                '${item.quantity}X',
                                '₹${item.totalPrice.toInt()}',
                              ),
                              const SizedBox(height: 10),
                            ],

                            if (controller.discount > 0) ...[
                              _buildBillRow(
                                'Discount',
                                '',
                                '-₹${controller.discount.toInt()}',
                              ),
                              const SizedBox(height: 10),
                            ],

                            if (controller.deliveryCharge > 0) ...[
                              _buildBillRow(
                                'Delivery Charge',
                                '',
                                '₹${controller.deliveryCharge.toInt()}',
                              ),
                              const SizedBox(height: 10),
                            ],

                            const Divider(
                              color: Color(0xFFF3F4F6),
                              height: 16,
                            ),
                            _buildBillRow(
                              'Total',
                              '',
                              '₹${controller.totalAmount.toInt()}',
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Estimate Delivery Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Estimate delivery time',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF66CA7A),
                            ),
                          ),
                          Text(
                            controller.estimatedDeliveryTime,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF66CA7A),
                            ),
                          ),
                        ],
                      ),

                      // Space for bottom button
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: CustomButton(
                  text: 'Continue',
                  onPressed: controller.continueToPayment,
                  height: 56,
                  backgroundColor: const Color(0xFFFF823E),
                  borderRadius: 16,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildOrderItem(OrderSummaryItemModel item) {
    final hasImage = item.image != null && item.image!.isNotEmpty;
    final isNetwork = hasImage &&
        (item.image!.startsWith('http://') ||
            item.image!.startsWith('https://'));

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFF1EB),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isNetwork
                ? Image.network(
                    item.image!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      productImg2,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    hasImage ? item.image! : productImg2,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      productImg2,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 4),
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF252B35),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: item.isVeg ? Colors.green : Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: item.isVeg ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.type,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (item.oldPrice > item.price && item.price > 0) ...[
                      Text(
                        '₹${item.oldPrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9E9E9E),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      '₹${item.price.toInt()}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFF823E),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF823E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Qty: ${item.quantity}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(
    String title,
    String qty,
    String price, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isBold
                  ? const Color(0xFF252B35)
                  : const Color(0xFF4B5563),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (qty.isNotEmpty)
          Expanded(
            flex: 1,
            child: Text(
              qty,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4B5563),
              ),
            ),
          )
        else
          const Spacer(),
        Expanded(
          flex: 1,
          child: Text(
            price,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isBold
                  ? const Color(0xFF252B35)
                  : const Color(0xFF252B35),
            ),
          ),
        ),
      ],
    );
  }
}
