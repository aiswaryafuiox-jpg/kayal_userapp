import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/presentation/controller/payment_method_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/widgets/custom_buttom.dart';

class PaymentMethodScreen extends StatelessWidget {
  PaymentMethodScreen({super.key});

  final PaymentMethodController controller = Get.put(PaymentMethodController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Payment Method',
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
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Payment Methods List
                  Obx(
                    () {
                      final selectedIndex = controller.selectedMethodIndex.value;
                      
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.paymentMethods.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final method = controller.paymentMethods[index];
                          final isSelected = selectedIndex == index;
                          
                          return GestureDetector(
                            onTap: () => controller.selectMethod(index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? AppColors.checkoutbackground 
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected 
                                      ? const Color(0xFFFDECEC) 
                                      : const Color(0xFFF0F0F0),
                                  width: 1.5,
                                ),
                                boxShadow: isSelected ? [] : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    method['icon'] == 'online' 
                                        ? Icons.receipt_long_outlined 
                                        : Icons.payments_outlined,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      method['title']!,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  
                  // Space for bottom button
                  const SizedBox(height: 100),
                ],
              ),
            ),
            
            // Pay Now Button at bottom
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: CustomButton(
                text: 'Pay Now',
                onPressed: controller.payNow,
                height: 56,
                backgroundColor: AppColors.primary,
                borderRadius: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
