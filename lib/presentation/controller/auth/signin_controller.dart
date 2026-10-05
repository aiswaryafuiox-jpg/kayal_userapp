import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/data/repository/signup_profile_repository_impl.dart';
import 'package:kayal_userapp/data/repository/signup_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/signup_profile_usecase.dart';
import 'package:kayal_userapp/domain/usecase/signup_usecase.dart';
import 'package:kayal_userapp/presentation/widgets/app_notification.dart';

class SignupController extends GetxController {
  final SignupUseCase _signupUseCase;
  final SignupProfileUseCase _signupProfileUseCase;

  SignupController({
    SignupUseCase? signupUseCase,
    SignupProfileUseCase? signupProfileUseCase,
  })  : _signupUseCase = signupUseCase ??
            (sl.isRegistered<SignupUseCase>()
                ? sl<SignupUseCase>()
                : SignupUseCase(SignupRepositoryImpl(ApiService()))),
        _signupProfileUseCase = signupProfileUseCase ??
            (sl.isRegistered<SignupProfileUseCase>()
                ? sl<SignupProfileUseCase>()
                : SignupProfileUseCase(
                    SignupProfileRepositoryImpl(ApiService())));

  // ==============================
  // TEXT CONTROLLERS
  // ==============================

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  // ==============================
  // LOADING
  // ==============================

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['phoneNumber'] != null) {
      final phone = args['phoneNumber'].toString();
      if (phone.isNotEmpty) {
        phoneController.text = phone;
        phoneController.selection = TextSelection.fromPosition(
          TextPosition(offset: phone.length),
        );
      }
    } else if (args is String && args.isNotEmpty) {
      phoneController.text = args;
      phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: args.length),
      );
    }

    if (phoneController.text.trim().isEmpty) {
      final savedPhone = LocalStorageService().getPhoneNumber() ??
          LocalStorageService().getString('phone_number');
      if (savedPhone != null && savedPhone.isNotEmpty) {
        phoneController.text = savedPhone;
        phoneController.selection = TextSelection.fromPosition(
          TextPosition(offset: savedPhone.length),
        );
      }
    }
  }

  // ==============================
  // SIGN UP
  // ==============================

  Future<void> signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();

    if (fullName.isEmpty) {
      showError('Please enter full name');
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

    final token = LocalStorageService().getString('auth_token');
    final hasToken = token != null &&
        token.trim().isNotEmpty &&
        !token.startsWith('pms_token_');

    if (hasToken) {
      try {
        isLoading.value = true;
        final response = await _signupProfileUseCase(fullName: fullName,email:email);
        if (response.success) {
          final storage = LocalStorageService();
          await storage.saveUserData(
            fullName: fullName,
            phoneNumber: phone.isNotEmpty ? phone : (response.data?.phone ?? ''),
            email: email.isNotEmpty ? email : (response.data?.email ?? ''),
          );

          AppNotification.showSuccess(
            title: 'Welcome',
            message: response.message.isNotEmpty
                ? response.message
                : 'Profile updated successfully',
          );

          final arguments = Get.arguments;
          Get.offAllNamed<void>(
            AppRoutes.addAddress,
            arguments: {
              'fullName': fullName,
              'phoneNumber': phone.isNotEmpty
                  ? phone
                  : (response.data?.phone ?? ''),
              'email': email.isNotEmpty
                  ? email
                  : (response.data?.email ?? ''),
              if (arguments is Map && arguments['redirect'] != null)
                'redirect': arguments['redirect'],
              if (arguments is Map && arguments['tab'] != null)
                'tab': arguments['tab'],
            },
          );
        } else {
          final errorMsg = response.formattedErrorMessage.isNotEmpty
              ? response.formattedErrorMessage
              : response.message;
          showError(errorMsg.isNotEmpty ? errorMsg : 'Failed to update profile');
        }
      } catch (e) {
        debugPrint('Signup profile error: $e');
        showError('Failed to save profile. Please try again.');
      } finally {
        isLoading.value = false;
      }
      return;
    }

    try {
      isLoading.value = true;

      final nameParts = fullName.split(RegExp(r'\s+'));
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final response = await _signupUseCase(
        firstName: firstName,
        lastName: lastName.isNotEmpty ? lastName : firstName,
        phoneNumber: phone,
        email: email,
      );

      if (response.success) {
        final storage = LocalStorageService();
        await storage.saveUserData(
          fullName: fullName,
          phoneNumber: phone,
          email: email,
        );

        final otp = response.data?.otp;
        final otpMessage = (otp != null && otp.isNotEmpty)
            ? 'OTP sent for registration. Your OTP is: $otp'
            : (response.message.isNotEmpty
                ? response.message
                : 'OTP sent for registration');

        AppNotification.showSuccess(
          title: 'Success',
          message: otpMessage,
        );

        final arguments = Get.arguments;
        Get.toNamed(
          AppRoutes.otpVerification,
          arguments: {
            'phoneNumber': phone,
            'tempUserId': response.data?.tempUserId,
            'otp': response.data?.otp,
            'isSignUp': true,
            'fullName': fullName,
            'email': email,
            if (arguments is Map && arguments['redirect'] != null)
              'redirect': arguments['redirect'],
            if (arguments is Map && arguments['tab'] != null)
              'tab': arguments['tab'],
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
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();

    super.onClose();
  }
}