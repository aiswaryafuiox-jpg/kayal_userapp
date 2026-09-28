import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static const Duration splashDuration = Duration(seconds: 4);

  late final AnimationController timeline;
  final LocalStorageService _storage = LocalStorageService();

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
      try {
        await _storage.init();
        // Initialize session ID for guest/user
        _storage.getOrCreateSessionId();

        final bool hasSeenOnboarding = _storage.hasSeenOnboarding();
        final bool isLoggedIn = _storage.isLoggedIn();

        if (hasSeenOnboarding || isLoggedIn) {
          Get.offAllNamed(AppRoutes.home);
        } else {
          Get.offAllNamed(AppRoutes.onboarding);
        }
      } catch (e) {
        debugPrint('LocalStorage error in splash controller: $e');
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
