import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/presentation/controller/success_controller.dart';
import 'package:kayal_userapp/presentation/widgets/custom_buttom.dart';

class SuccessScreen extends StatelessWidget {
  SuccessScreen({super.key});

  final SuccessController controller = Get.put(SuccessController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Green Checkmark SVG
                      SvgPicture.asset(
                        successIllustration,
                        height: 120,
                      ),
                      const SizedBox(height: 24),
                      
                      // Success Text
                      const Text(
                        'Your Order Placed\nSuccessfully',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.grey,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Food Illustration PNG
                      Image.asset(
                        successImg,
                        height: 220,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Estimated Delivery Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFEFE6), // Soft orange background
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.access_time_filled,
                            color: Color(0xFFC05912), // Darker orange/brown icon color
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ESTIMATED DELIVERY',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '25 - 35 Minutes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Track Order Button
                  CustomButton(
                    text: 'Track Order',
                    onPressed: controller.trackOrder,
                    height: 56,
                    backgroundColor: AppColors.primary,
                    borderRadius: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
