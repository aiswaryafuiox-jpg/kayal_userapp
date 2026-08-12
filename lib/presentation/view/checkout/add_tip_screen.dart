import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/presentation/controller/add_tip_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/widgets/custom_buttom.dart';

class AddTipScreen extends StatelessWidget {
  AddTipScreen({super.key});

  final AddTipController controller = Get.put(AddTipController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Add Tip',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    tipPersonImg,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Thank you Delivery partner',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '100% of your tip goes to your\ndelivery partner',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF9CA3AF),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Choose Tip Amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Predefined Tip Amounts Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: controller.tipOptions.length,
                    itemBuilder: (context, index) {
                      final amount = controller.tipOptions[index];
                      
                      return Obx(() {
                        final isSelected = controller.selectedTip.value == amount;
                        return GestureDetector(
                          onTap: () => controller.selectTip(amount),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.checkoutbackground : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected 
                                    ? AppColors.primary 
                                    : const Color(0xFFE5E7EB),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              '₹$amount',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppColors.primary : AppColors.grey,
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Custom Tip TextField
                  TextFormField(
                    controller: controller.customTipController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: controller.onCustomTipChanged,
                    decoration: InputDecoration(
                      hintText: 'Enter your Custom Amount',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  
                  // Space for bottom button
                  const SizedBox(height: 100),
                ],
              ),
            ),
            
            // Continue Button at bottom
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: CustomButton(
                text: 'Continue',
                onPressed: controller.continueToNext,
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
