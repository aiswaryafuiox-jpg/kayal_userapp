import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/order_summary_response_model.dart';
import 'package:kayal_userapp/presentation/controller/order_summary_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/widgets/custom_buttom.dart';

class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen({super.key});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late final OrderSummaryController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<OrderSummaryController>()
        ? Get.find<OrderSummaryController>()
        : Get.put(OrderSummaryController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controller.updateArguments(Get.arguments);
      }
    });
  }

  String _resolveImageUrl(String? path) {
    if (path == null || path.isEmpty || path == 'null') return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    if (path.startsWith('assets/')) return path;
    return '${ApiRoutes.imageBaseURL}$path';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppBar(
          title: 'Order Summary',
          showBackButton: true,
        ),
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
                    Text(
                      'Your order is empty',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF252B35),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add dishes to your cart or select an item from the menu to proceed with your order.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF6B7280),
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

          return RefreshIndicator(
            onRefresh: () => controller.fetchOrderSummary(),
            color: const Color(0xFFFF823E),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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

                  // // Add Special Instructions
                  // GestureDetector(
                  //   onTap: controller.addSpecialInstructions,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 16,
                  //       vertical: 14,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(12),
                  //       border: Border.all(color: const Color(0xFFF3F4F6)),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         const Icon(
                  //           Icons.article_outlined,
                  //           color: Color(0xFF6B7280),
                  //           size: 20,
                  //         ),
                  //         const SizedBox(width: 8),
                  //         Expanded(
                  //           child: Text(
                  //             controller.specialInstructions.value.isNotEmpty
                  //                 ? 'Instructions: ${controller.specialInstructions.value}'
                  //                 : 'Add Special instructions',
                  //             style: GoogleFonts.inter(
                  //               fontSize: 14,
                  //               fontWeight: FontWeight.w500,
                  //               color: controller
                  //                       .specialInstructions.value.isNotEmpty
                  //                   ? const Color(0xFFFF823E)
                  //                   : const Color(0xFF252B35),
                  //             ),
                  //             maxLines: 1,
                  //             overflow: TextOverflow.ellipsis,
                  //           ),
                  //         ),
                  //         const Icon(
                  //           Icons.chevron_right,
                  //           color: Color(0xFF9E9E9E),
                  //           size: 20,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 24),

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
                        // Items Breakdown
                        for (var item in controller.items) ...[
                          _buildBillRow(
                            item.name,
                            '${item.quantity}X',
                            '₹${(item.totalPrice > 0 ? item.totalPrice : (item.price * item.quantity)).toInt()}',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF252B35),
                              ),
                            ),
                            Text(
                              '₹${controller.totalAmount.toInt()}',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFF823E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Estimate Delivery Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estimate delivery time',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF66CA7A),
                        ),
                      ),
                      Text(
                        controller.estimatedDeliveryTime,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF66CA7A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Continue Button
                  CustomButton(
                    text: 'Continue',
                    onPressed: controller.continueToPayment,
                    height: 54,
                    backgroundColor: AppColors.primary,
                    borderRadius: 16,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOrderItem(OrderSummaryItemModel item) {
    final resolvedImage = _resolveImageUrl(item.image);

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
            child: resolvedImage.startsWith('http://') ||
                    resolvedImage.startsWith('https://')
                ? Image.network(
                    resolvedImage,
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
                    resolvedImage.isNotEmpty ? resolvedImage : productImg2,
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
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF252B35),
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
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6B7280),
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
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF9E9E9E),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      '₹${item.price.toInt()}',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFF823E),
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
                        style: GoogleFonts.inter(
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
            style: GoogleFonts.inter(
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
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF4B5563),
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
            style: GoogleFonts.inter(
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
