import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/repository/login_otp_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/login_otp_usecase.dart';
import 'package:kayal_userapp/presentation/widgets/app_notification.dart';

class LoginController extends GetxController {
  final LoginOtpUseCase _loginOtpUseCase;

  LoginController({LoginOtpUseCase? loginOtpUseCase})
      : _loginOtpUseCase = loginOtpUseCase ??
            (sl.isRegistered<LoginOtpUseCase>()
                ? sl<LoginOtpUseCase>()
                : LoginOtpUseCase(LoginOtpRepositoryImpl(ApiService())));

  final TextEditingController phoneController = TextEditingController();
  final RxBool isLoading = false.obs;

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
  }

  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final phoneNumber = phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      AppNotification.showError(
        title: 'Phone Number Required',
        message: 'Please enter your phone number.',
      );
      return;
    }

    if (phoneNumber.length < 10) {
      AppNotification.showError(
        title: 'Invalid Phone Number',
        message: 'Enter a valid 10-digit phone number.',
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _loginOtpUseCase(
        phoneNumber: phoneNumber,
      );

      if (response.success) {
        final otp = response.data?.otp;
        final otpMessage = (otp != null && otp.isNotEmpty)
            ? 'OTP sent successfully. Your OTP is: $otp'
            : (response.message.isNotEmpty
                ? response.message
                : 'OTP sent successfully');

        AppNotification.showSuccess(
          title: 'OTP Sent',
          message: otpMessage,
        );

        final arguments = Get.arguments;
        final nextArgs = {
          'phoneNumber': phoneNumber,
          'otp': response.data?.otp,
          'expiresIn': response.data?.expiresIn,
          'userId': response.data?.userId,
          'isVerified': response.data?.isVerified,
          'isSignUp': false,
          if (arguments is Map && arguments['redirect'] != null)
            'redirect': arguments['redirect'],
          if (arguments is Map && arguments['tab'] != null)
            'tab': arguments['tab'],
        };

        Get.toNamed<void>(AppRoutes.otpVerification, arguments: nextArgs);
      } else {
        final errorMsg = response.formattedErrorMessage.isNotEmpty
            ? response.formattedErrorMessage
            : response.message;
        AppNotification.showError(
          title: 'Login Failed',
          message: errorMsg.isNotEmpty ? errorMsg : 'Failed to send OTP.',
        );
      }
    } catch (e) {
      debugPrint('login error: $e');
      AppNotification.showError(
        title: 'Error',
        message: 'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
