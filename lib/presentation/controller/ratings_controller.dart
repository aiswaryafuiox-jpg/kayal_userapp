import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';

class RatingsController extends GetxController {
  final rating = 0.obs;
  final reviewTextController = TextEditingController();

  void setRating(int value) {
    rating.value = value;
  }

  void submitReview() {
    if (rating.value == 0) {
      Get.snackbar(
        'Warning',
        'Please tap to select a rating star first.',
        backgroundColor: Colors.amber.shade100,
        colorText: Colors.black87,
      );
      return;
    }
    
    Get.snackbar(
      'Review Submitted',
      'Thank you for your rating of ${rating.value} stars!',
      backgroundColor: const Color(0xFFDCFCE7),
      colorText: const Color(0xFF15803D),
    );
    
    // Go back to Home
    Get.offAllNamed(AppRoutes.home);
  }

  void skip() {
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void onClose() {
    reviewTextController.dispose();
    super.onClose();
  }
}
