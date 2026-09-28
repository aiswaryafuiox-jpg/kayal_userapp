import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/repository/resend_login_otp_repository_impl.dart';
import 'package:kayal_userapp/data/repository/resend_signup_otp_repository_impl.dart';
import 'package:kayal_userapp/data/repository/verify_login_otp_repository_impl.dart';
import 'package:kayal_userapp/data/repository/verify_signup_otp_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/resend_login_otp_usecase.dart';
import 'package:kayal_userapp/domain/usecase/resend_signup_otp_usecase.dart';
import 'package:kayal_userapp/domain/usecase/verify_login_otp_usecase.dart';
import 'package:kayal_userapp/domain/usecase/verify_signup_otp_usecase.dart';
import 'package:kayal_userapp/presentation/controller/auth/login_controller.dart';
import 'package:kayal_userapp/presentation/controller/auth/signin_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_notification.dart';

class OtpController extends GetxController {
  static const int otpLength = 4;

  final VerifySignupOtpUseCase _verifySignupOtpUseCase;
  final VerifyLoginOtpUseCase _verifyLoginOtpUseCase;
  final ResendSignupOtpUseCase _resendSignupOtpUseCase;
  final ResendLoginOtpUseCase _resendLoginOtpUseCase;

  OtpController({
    VerifySignupOtpUseCase? verifySignupOtpUseCase,
    VerifyLoginOtpUseCase? verifyLoginOtpUseCase,
    ResendSignupOtpUseCase? resendSignupOtpUseCase,
    ResendLoginOtpUseCase? resendLoginOtpUseCase,
  }) : _verifySignupOtpUseCase =
           verifySignupOtpUseCase ??
           (sl.isRegistered<VerifySignupOtpUseCase>()
               ? sl<VerifySignupOtpUseCase>()
               : VerifySignupOtpUseCase(
                   VerifySignupOtpRepositoryImpl(ApiService()),
                 )),
       _verifyLoginOtpUseCase =
           verifyLoginOtpUseCase ??
           (sl.isRegistered<VerifyLoginOtpUseCase>()
               ? sl<VerifyLoginOtpUseCase>()
               : VerifyLoginOtpUseCase(
                   VerifyLoginOtpRepositoryImpl(ApiService()),
                 )),
       _resendSignupOtpUseCase =
           resendSignupOtpUseCase ??
           (sl.isRegistered<ResendSignupOtpUseCase>()
               ? sl<ResendSignupOtpUseCase>()
               : ResendSignupOtpUseCase(
                   ResendSignupOtpRepositoryImpl(ApiService()),
                 )),
       _resendLoginOtpUseCase =
           resendLoginOtpUseCase ??
           (sl.isRegistered<ResendLoginOtpUseCase>()
               ? sl<ResendLoginOtpUseCase>()
               : ResendLoginOtpUseCase(
                   ResendLoginOtpRepositoryImpl(ApiService()),
                 ));

  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();
  final RxString otp = ''.obs;
  final RxInt activeDigit = 0.obs;
  final RxInt secondsRemaining = 30.obs;
  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;

  Timer? _timer;

  String get phoneNumber {
    final argument = Get.arguments;
    if (argument is Map && argument.containsKey('phoneNumber')) {
      return argument['phoneNumber'] ?? '7685342317';
    }
    return argument is String && argument.isNotEmpty ? argument : '7685342317';
  }

  bool get isSignUp {
    final argument = Get.arguments;
    if (argument is Map && argument.containsKey('isSignUp')) {
      return argument['isSignUp'] == true;
    }
    return false;
  }

  String get formattedPhoneNumber => '+91 $phoneNumber';

  String get countdown {
    final seconds = secondsRemaining.value.toString().padLeft(2, '0');
    return '00:$seconds';
  }

  bool get canResend => secondsRemaining.value == 0 && !isResending.value;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
    otpFocusNode.addListener(_handleFocusChange);

    final argument = Get.arguments;
    if (argument is Map && argument['otp'] != null) {
      final passedOtp = argument['otp'].toString();
      if (passedOtp.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppNotification.showSuccess(
            title: 'Your OTP',
            message: 'Your verification OTP is: $passedOtp',
          );
          otpFocusNode.requestFocus();
        });
      }
    }
  }

  void onOtpChanged(String value) {
    otp.value = value;
    activeDigit.value = value.length >= otpLength
        ? otpLength - 1
        : value.length;
  }

  void selectDigit(int index) {
    activeDigit.value = index;
    final textLength = otpController.text.length;

    if (index < textLength) {
      otpController.selection = TextSelection(
        baseOffset: index,
        extentOffset: index + 1,
      );
    } else {
      otpController.selection = TextSelection.collapsed(offset: textLength);
    }

    otpFocusNode.requestFocus();
  }

  void editPhoneNumber() {
    if (isSignUp) {
      if (Get.isRegistered<SignupController>()) {
        final signupCtrl = Get.find<SignupController>();
        if (phoneNumber.isNotEmpty) {
          signupCtrl.phoneController.text = phoneNumber;
          signupCtrl.phoneController.selection = TextSelection.fromPosition(
            TextPosition(offset: phoneNumber.length),
          );
        }
      }
      if (Get.previousRoute == AppRoutes.signin) {
        Get.back();
      } else {
        Get.offAllNamed<void>(
          AppRoutes.signin,
          arguments: {'phoneNumber': phoneNumber},
        );
      }
    } else {
      if (Get.isRegistered<LoginController>()) {
        final loginCtrl = Get.find<LoginController>();
        if (phoneNumber.isNotEmpty) {
          loginCtrl.phoneController.text = phoneNumber;
          loginCtrl.phoneController.selection = TextSelection.fromPosition(
            TextPosition(offset: phoneNumber.length),
          );
        }
      }
      if (Get.previousRoute == AppRoutes.login) {
        Get.back();
      } else {
        Get.offAllNamed<void>(
          AppRoutes.login,
          arguments: {'phoneNumber': phoneNumber},
        );
      }
    }
  }

  Future<void> verifyOtp() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (otpController.text.length != otpLength) {
      AppNotification.showError(
        title: 'Incomplete OTP',
        message: 'Enter the complete verification code.',
      );
      return;
    }

    final argument = Get.arguments;

    try {
      isLoading.value = true;

      if (isSignUp) {
        final response = await _verifySignupOtpUseCase(
          phoneNumber: phoneNumber,
          otpCode: otpController.text.trim(),
        );

        if (response.success) {
          final storage = LocalStorageService();
          if (response.data != null && response.data!.token.isNotEmpty) {
            await storage.saveString('auth_token', response.data!.token);
            await storage.saveString('user_id', response.data!.userId);
            await storage.saveBool('is_logged_in', true);
          }
          if (phoneNumber.isNotEmpty) {
            await storage.saveString('phone_number', phoneNumber);
          }
          if (argument is Map) {
            final argName = argument['fullName']?.toString() ?? argument['name']?.toString();
            final argEmail = argument['email']?.toString();
            if (argName != null && argName.isNotEmpty) {
              await storage.saveString('full_name', argName);
              await storage.saveString('user_name', argName);
            }
            if (argEmail != null && argEmail.isNotEmpty) {
              await storage.saveString('email', argEmail);
            }
          }

          AppNotification.showSuccess(
            title: 'Verified',
            message: response.message.isNotEmpty
                ? response.message
                : 'Account created successfully',
          );

          Get.offNamed<void>(
            AppRoutes.verificationSuccess,
            arguments: {
              'phoneNumber': phoneNumber,
              'isRegistered': false,
              if (argument is Map && argument['fullName'] != null)
                'fullName': argument['fullName'],
              if (argument is Map && argument['email'] != null)
                'email': argument['email'],
              if (argument is Map && argument['redirect'] != null)
                'redirect': argument['redirect'],
              if (argument is Map && argument['tab'] != null)
                'tab': argument['tab'],
            },
          );
        } else {
          final errorMsg = response.formattedErrorMessage.isNotEmpty
              ? response.formattedErrorMessage
              : response.message;
          AppNotification.showError(
            title: 'Verification Failed',
            message: errorMsg.isNotEmpty ? errorMsg : 'Invalid OTP entered',
          );
        }
      } else {
        final response = await _verifyLoginOtpUseCase(
          phoneNumber: phoneNumber,
          otpCode: otpController.text.trim(),
        );

        if (response.success) {
          final storage = LocalStorageService();
          if (response.data != null && response.data!.token.isNotEmpty) {
            await storage.saveString('auth_token', response.data!.token);
            await storage.saveString('user_id', response.data!.userId);
            await storage.saveBool('is_logged_in', true);
          }
          if (phoneNumber.isNotEmpty) {
            await storage.saveString('phone_number', phoneNumber);
          }

          AppNotification.showSuccess(
            title: 'Verified',
            message: response.message.isNotEmpty
                ? response.message
                : 'Login successful',
          );

          final bool isRegistered = response.data?.isRegistered ?? false;

          Get.offNamed<void>(
            AppRoutes.verificationSuccess,
            arguments: {
              'phoneNumber': phoneNumber,
              'isRegistered': isRegistered,
              if (argument is Map && argument['redirect'] != null)
                'redirect': argument['redirect'],
              if (argument is Map && argument['tab'] != null)
                'tab': argument['tab'],
            },
          );
        } else {
          final errorMsg = response.formattedErrorMessage.isNotEmpty
              ? response.formattedErrorMessage
              : response.message;
          AppNotification.showError(
            title: 'Verification Failed',
            message: errorMsg.isNotEmpty ? errorMsg : 'Invalid OTP entered',
          );
        }
      }
    } catch (e) {
      debugPrint('verifyOtp error: $e');
      AppNotification.showError(
        title: 'Error',
        message: 'Failed to verify OTP. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!canResend) {
      return;
    }

    try {
      isResending.value = true;

      if (isSignUp) {
        final response = await _resendSignupOtpUseCase(
          phoneNumber: phoneNumber,
        );

        if (response.success) {
          _resetOtpState();
          final otp = response.data?.otp;
          final otpMsg = (otp != null && otp.isNotEmpty)
              ? 'Signup OTP resent successfully. Your OTP is: $otp'
              : (response.message.isNotEmpty
                  ? response.message
                  : 'Signup OTP resent successfully.');
          AppNotification.showSuccess(
            title: 'OTP Sent',
            message: otpMsg,
          );
        } else {
          final errorMsg = response.formattedErrorMessage.isNotEmpty
              ? response.formattedErrorMessage
              : response.message;
          AppNotification.showError(
            title: 'Resend Failed',
            message: errorMsg.isNotEmpty ? errorMsg : 'Failed to resend OTP.',
          );
        }
      } else {
        final response = await _resendLoginOtpUseCase(phoneNumber: phoneNumber);

        if (response.success) {
          _resetOtpState();
          final otp = response.data?.otp;
          final otpMsg = (otp != null && otp.isNotEmpty)
              ? 'Login OTP resent successfully. Your OTP is: $otp'
              : (response.message.isNotEmpty
                  ? response.message
                  : 'Login OTP resent successfully.');
          AppNotification.showSuccess(
            title: 'OTP Sent',
            message: otpMsg,
          );
        } else {
          final errorMsg = response.formattedErrorMessage.isNotEmpty
              ? response.formattedErrorMessage
              : response.message;
          AppNotification.showError(
            title: 'Resend Failed',
            message: errorMsg.isNotEmpty ? errorMsg : 'Failed to resend OTP.',
          );
        }
      }
    } catch (e) {
      debugPrint('resendOtp error: $e');
      AppNotification.showError(
        title: 'Error',
        message: 'Unable to resend OTP. Please try again.',
      );
    } finally {
      isResending.value = false;
    }
  }

  void _resetOtpState() {
    otpController.clear();
    otp.value = '';
    activeDigit.value = 0;
    secondsRemaining.value = 30;
    otpFocusNode.requestFocus();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value == 0) {
        timer.cancel();
        return;
      }
      secondsRemaining.value--;
    });
  }

  void _handleFocusChange() {
    if (!otpFocusNode.hasFocus) {
      activeDigit.value = -1;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpFocusNode.removeListener(_handleFocusChange);
    otpFocusNode.dispose();
    otpController.dispose();
    super.onClose();
  }
}
