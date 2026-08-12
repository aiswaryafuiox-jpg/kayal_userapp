import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  // ==============================
  // TEXT CONTROLLERS
  // ==============================

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  // ==============================
  // LOADING
  // ==============================

  final isLoading = false.obs;

  // ==============================
  // SIGN UP
  // ==============================

  Future<void> signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (firstNameController.text.trim().isEmpty) {
      showError('Please enter first name');
      return;
    }

    if (lastNameController.text.trim().isEmpty) {
      showError('Please enter last name');
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      showError('Please enter phone number');
      return;
    }

    if (phoneController.text.trim().length < 10) {
      showError('Please enter a valid phone number');
      return;
    }

    if (emailController.text.trim().isEmpty) {
      showError('Please enter email');
      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      showError('Please enter a valid email');
      return;
    }

    try {
      isLoading.value = true;

      // ==============================
      // API CALL HERE
      // ==============================

      await Future.delayed(
        const Duration(seconds: 2),
      );

      debugPrint(
        'First Name: ${firstNameController.text}',
      );

      debugPrint(
        'Last Name: ${lastNameController.text}',
      );

      debugPrint(
        'Phone: ${phoneController.text}',
      );

      debugPrint(
        'Email: ${emailController.text}',
      );

      // Example navigation
      // Get.toNamed('/otp');

    } catch (e) {
      showError('Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.back();
    // Or:
    // Get.toNamed('/login');
  }

  void showError(String message) {
    Get.snackbar(
      'Sign up',
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();

    super.onClose();
  }
}