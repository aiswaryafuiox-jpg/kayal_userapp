import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';

class SplashController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController logoController;
  late AnimationController backgroundController;

  late Animation<double> logoScale;
  late Animation<double> logoFade;
  late Animation<Offset> logoPosition;

  late Animation<double> backgroundScale;
  late Animation<double> backgroundOpacity;

  @override
  void onInit() {
    super.onInit();

    // Logo animation controller
    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Logo scale: 0.65 -> 1.08 -> 1.0
    logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.65,
          end: 1.08,
        ).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.08,
          end: 1.0,
        ).chain(
          CurveTween(curve: Curves.elasticOut),
        ),
        weight: 30,
      ),
    ]).animate(logoController);

    // Logo fade
    logoFade = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(
          curve: const Interval(
            0.0,
            0.45,
            curve: Curves.easeIn,
          ),
        ))
        .animate(logoController);

    // Logo slide
    logoPosition = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    )
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(logoController);

    // Background animation
    backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    backgroundScale = Tween<double>(
      begin: 1.0,
      end: 1.025,
    )
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(backgroundController);

    backgroundOpacity = Tween<double>(
      begin: 0.94,
      end: 1.0,
    )
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(backgroundController);
  }

  @override
  void onReady() {
    super.onReady();

    // Start animations
    logoController.forward();
    backgroundController.repeat(reverse: true);

    // Go to Onboarding
    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (!isClosed) {
          Get.offAllNamed(AppRoutes.onboarding);
        }
      },
    );
  }

  @override
  void onClose() {
    logoController.dispose();
    backgroundController.dispose();

    super.onClose();
  }
}