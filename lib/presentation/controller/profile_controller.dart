import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';

import 'package:kayal_userapp/presentation/view/profile/edit_profile_screen.dart';
import 'package:kayal_userapp/presentation/view/profile/privacy_policy_screen.dart';
import 'package:kayal_userapp/presentation/view/profile/terms_condition_screen.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final userName = 'Lunna'.obs;
  final phoneNumber = '+91 896745321'.obs;
  final profileImage = profileImg.obs; // Use appropriate image, maybe a user placeholder

  void editProfile() {
    Get.to(() => const EditProfileScreen());
  }

  void openMyOrders() {
    Get.toNamed(AppRoutes.orders);
  }

  void openCart() {
    Get.toNamed(AppRoutes.cart);
  }

  void openSavedAddress() {
    Get.toNamed(AppRoutes.addAddress);
  }

  void openWishlist() {
    Get.toNamed(AppRoutes.wishlist);
  }

  void openFeedback() {
    Get.toNamed(AppRoutes.feedback);
  }

  void openPrivacyPolicy() {
    Get.to(() => const PrivacyPolicyScreen());
  }

  void openTermsCondition() {
    Get.to(() => const TermsConditionScreen());
  }

  void logOut() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout,
                color: Color(0xFFF03636), // AppColors.red equivalent
                size: 32,
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you Sure !!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Are you Confirm to Logout ?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9CA3AF),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFF03636)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF03636),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', false);
                        Get.offAllNamed(AppRoutes.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF03636),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Yes, Sure',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
