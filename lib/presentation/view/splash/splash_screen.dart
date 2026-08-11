import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';

import '../../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller =
      Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          alignment: Alignment.center,
          children: [

            // =========================
            // BACKGROUND
            // =========================

            AnimatedBuilder(
              animation: controller.backgroundController,
              builder: (context, child) {
                return Opacity(
                  opacity: controller.backgroundOpacity.value,
                  child: Transform.scale(
                    scale: controller.backgroundScale.value,
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                splashBackground,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // =========================
            // KAYAL LOGO
            // =========================

            SlideTransition(
              position: controller.logoPosition,
              child: FadeTransition(
                opacity: controller.logoFade,
                child: ScaleTransition(
                  scale: controller.logoScale,
                  child: Image.asset(
                    appLogo,
                    width: 145,
                    height: 155,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}