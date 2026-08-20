import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static const Duration splashDuration = Duration(seconds: 5);

  late final AnimationController timeline;

  @override
  void onInit() {
    super.onInit();
    timeline = AnimationController(vsync: this, duration: splashDuration);
  }

  @override
  void onReady() {
    super.onReady();
    timeline.forward();
    Future<void>.delayed(splashDuration, () async {
      if (isClosed) return;
      bool isLoggedIn = false;
      bool hasSeenOnboarding = false;
      try {
        final prefs = await SharedPreferences.getInstance();
        isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
        hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
      } catch (e) {
        debugPrint('SharedPreferences error in splash controller: $e');
      }

      if (isLoggedIn || hasSeenOnboarding) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.onboarding);
      }
    });
  }

  @override
  void onClose() {
    timeline.dispose();
    super.onClose();
  }
}
