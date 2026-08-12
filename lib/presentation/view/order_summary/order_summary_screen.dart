import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/presentation/controller/order_summary_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/widgets/custom_buttom.dart';

class OrderSummaryScreen extends StatelessWidget {
  OrderSummaryScreen({super.key});

  final OrderSummaryController controller = Get.put(OrderSummaryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      appBar: CustomAppBar(
        title: 'Order Summary',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Items List
                  _buildOrderItem(),
                  const SizedBox(height: 16),
                  _buildOrderItem(),
                  const SizedBox(height: 24),
                  
                  // Add Special Instructions
                  GestureDetector(
                    onTap: controller.addSpecialInstructions,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.article_outlined,
                          color: Color(0xFF6B7280),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Add Special instructions',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF252B35),
                            ),
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
                  const SizedBox(height: 32),

                  // Total Amount Box
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF252B35),
                              ),
                            ),
                            Text(
                              '₹360',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFF823E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildBillRow('Chicken Pizza', '2X', '₹ 240'),
                        const SizedBox(height: 12),
                        _buildBillRow('Discount', '', '-₹20'),
                        const SizedBox(height: 12),
                        _buildBillRow('Total', '', '₹220', isBold: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Estimate Delivery Time
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estimate delivery time',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF66CA7A),
                        ),
                      ),
                      Text(
                        '20-25 mins',
                        style: TextStyle(
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
        ),
      ),
    );
  }

  Widget _buildOrderItem() {
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
            child: Image.asset(
              productImg2,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 4),
                const Text(
                  'Chicken Pizza',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF252B35),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Non-Veg',
                      style: TextStyle(
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
                    const Text(
                      '₹220',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9E9E9E),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '₹180',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFF823E),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF823E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Qty: 1',
                        style: TextStyle(
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

  Widget _buildBillRow(String title, String qty, String price, {bool isBold = false}) {
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
              color: isBold ? const Color(0xFF252B35) : const Color(0xFF4B5563),
            ),
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
              color: isBold ? const Color(0xFF252B35) : const Color(0xFF252B35),
            ),
          ),
        ),
      ],
    );
  }
}
