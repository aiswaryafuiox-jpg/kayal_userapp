import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/presentation/widgets/app_notification.dart';


class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();

  void login() {
    final phoneNumber = phoneController.text.trim();

    if (phoneNumber.length < 10) {
      AppNotification.showError(
        title: 'Invalid phone number',
        message: 'Enter a valid 10-digit phone number.',
      );
      return;
    }

    final arguments = Get.arguments;
    dynamic nextArgs;
    if (arguments is Map) {
      nextArgs = {
        'phoneNumber': phoneNumber,
        'redirect': arguments['redirect'],
      };
    } else {
      nextArgs = phoneNumber;
    }

    Get.toNamed<void>(AppRoutes.otpVerification, arguments: nextArgs);
  }

}
