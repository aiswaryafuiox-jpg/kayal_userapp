import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/presentation/controller/splash_controller.dart';
import 'package:kayal_userapp/presentation/view/splash/splash_screen.dart';

void main() {
  testWidgets('captures the premium energy moment', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(MaterialApp(home: SplashScreen()));
    final controller = Get.find<SplashController>();
    controller.timeline.value = 0.24;
    controller.timeline.stop();
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 250)),
    );
    await tester.pump();
    await expectLater(
      find.byType(SplashScreen),
      matchesGoldenFile('goldens/splash_energy.png'),
    );
    controller.timeline.value = 0.92;
    await tester.pump();
    await expectLater(
      find.byType(SplashScreen),
      matchesGoldenFile('goldens/splash_final.png'),
    );
    Get.delete<SplashController>(force: true);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 5100));
    await tester.binding.setSurfaceSize(null);
    Get.reset();
  });
}
