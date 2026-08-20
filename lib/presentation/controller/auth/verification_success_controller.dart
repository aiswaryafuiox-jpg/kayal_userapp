import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';


class VerificationSuccessController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> fadeAnimation;
  late final Animation<double> scaleAnimation;
  Timer? _homeTimer;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    final curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOutBack,
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );
    scaleAnimation = Tween<double>(
      begin: 0.75,
      end: 1,
    ).animate(curvedAnimation);

    animationController.forward();
    _saveLoginStatus();
    _homeTimer = Timer(const Duration(seconds: 5), () async {
      final arguments = Get.arguments;
      if (arguments is Map && arguments['redirect'] != null) {
        final String redirectRoute = arguments['redirect'];
        if (redirectRoute == AppRoutes.home && arguments['tab'] != null) {
          Get.offAllNamed<void>(
            redirectRoute,
            arguments: {'tab': arguments['tab']},
          );
        } else {
          Get.offAllNamed<void>(redirectRoute);
        }
      } else {
        Get.offAllNamed<void>(AppRoutes.location);
      }
    });
  }

  Future<void> _saveLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  @override
  void onClose() {
    _homeTimer?.cancel();
    animationController.dispose();
    super.onClose();
  }
}
