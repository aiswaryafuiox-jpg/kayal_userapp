import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/repository/signup_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/signup_usecase.dart';
import 'package:kayal_userapp/presentation/widgets/app_notification.dart';

class SignupController extends GetxController {
  final SignupUseCase _signupUseCase;

  SignupController({SignupUseCase? signupUseCase})
      : _signupUseCase = signupUseCase ??
            (sl.isRegistered<SignupUseCase>()
                ? sl<SignupUseCase>()
                : SignupUseCase(SignupRepositoryImpl(ApiService())));

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

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();

    if (firstName.isEmpty) {
      showError('Please enter first name');
      return;
    }

    if (lastName.isEmpty) {
      showError('Please enter last name');
      return;
    }

    if (phone.isEmpty) {
      showError('Please enter phone number');
      return;
    }

    if (phone.length < 10) {
      showError('Please enter a valid 10-digit phone number');
      return;
    }

    if (email.isEmpty) {
      showError('Please enter email');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      showError('Please enter a valid email address');
      return;
    }

    try {
      isLoading.value = true;

      final response = await _signupUseCase(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phone,
        email: email,
      );

      if (response.success) {
        AppNotification.showSuccess(
          title: 'Success',
          message: response.message.isNotEmpty
              ? response.message
              : 'OTP sent for registration',
        );

        Get.toNamed(
          AppRoutes.otpVerification,
          arguments: {
            'phoneNumber': phone,
            'tempUserId': response.data?.tempUserId,
            'otp': response.data?.otp,
            'isSignUp': true,
          },
        );
      } else {
        final errorMsg = response.formattedErrorMessage.isNotEmpty
            ? response.formattedErrorMessage
            : response.message;
        showError(errorMsg.isNotEmpty ? errorMsg : 'Registration failed');
      }
    } catch (e) {
      debugPrint('Signup error: $e');
      showError('Failed to sign up. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.back();
  }

  void showError(String message) {
    AppNotification.showError(
      title: 'Sign Up Error',
      message: message,
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