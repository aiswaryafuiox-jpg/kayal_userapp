import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/main.dart';
import 'package:kayal_userapp/presentation/view/onboarding/onboarding_screen.dart';
import 'package:kayal_userapp/presentation/view/splash/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('plays the branded splash and continues to onboarding', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MyApp());
    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
    final logo = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == appLogo,
    );
    expect(logo, findsOneWidget);
    expect(find.bySemanticsLabel('Kayal Food Delivery'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 4200));
    await tester.pump();
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
