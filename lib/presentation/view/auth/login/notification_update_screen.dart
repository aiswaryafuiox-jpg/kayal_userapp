import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/utils/helper/texthelper.dart';
import 'package:kayal_userapp/presentation/controller/auth/notification_update_controller.dart';
import 'package:kayal_userapp/presentation/widgets/custom_buttom.dart';

class NotificationUpdateScreen extends StatelessWidget {
  NotificationUpdateScreen({super.key});

  final NotificationUpdateController controller =
      Get.put(NotificationUpdateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 62),

                        // Title
                        Text(
                          'Get updates on your order status',
                          style: TextHelper.heading3,
                        ),

                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          'Allow push notifications to get real-time updates on your order status',
                          style: TextHelper.heading2,
                        ),

                        const Spacer(),

                        // Center Illustration
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 22.0),
                            child: Image.asset(
                              notificationImg,
                              width: double.infinity,
                              height: constraints.maxHeight * 0.40,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Continue Button
                        Obx(
                          () => CustomButton(
                            text: 'Continue',
                            height: 48,
                            borderRadius: 8,
                            backgroundColor: const Color(0xFFFF823E),
                            textColor: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            isLoading: controller.isLoading.value,
                            onPressed: controller.onContinue,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Not Now Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: controller.onNotNow,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color(0xFFFFE1D2),
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Not Now',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E2430),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
