import 'package:get/get.dart';
import 'package:kayal_userapp/presentation/controller/auth/confirm_location_controller.dart';
import 'package:kayal_userapp/presentation/controller/auth/location_controller.dart';
import 'package:kayal_userapp/presentation/controller/auth/login_controller.dart';
import 'package:kayal_userapp/presentation/controller/auth/otp_controller.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';
import 'package:kayal_userapp/presentation/controller/onboarding_controller.dart';
import 'package:kayal_userapp/presentation/controller/splash_controller.dart';
import 'package:kayal_userapp/presentation/view/auth/login/confirm_location_screen.dart';
import 'package:kayal_userapp/presentation/view/auth/login/location_screen.dart';
import 'package:kayal_userapp/presentation/view/auth/login/login_screen.dart';
import 'package:kayal_userapp/presentation/view/auth/login/otp_verification_screen.dart';
import 'package:kayal_userapp/presentation/view/home/homescreen.dart';
import 'package:kayal_userapp/presentation/view/onboarding/onboarding_screen.dart';
import 'package:kayal_userapp/presentation/view/splash/splash_screen.dart';


class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otpVerification = '/otpVerification';
  static const String location = '/location';
  static const String confirmlocation = '/confirmlocation';
  static const String home = '/home';

 
  


  static List<GetPage<dynamic>> get pages => [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
      binding: BindingsBuilder.put(SplashController.new),
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingScreen(),
      binding: BindingsBuilder.put(OnboardingController.new),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder.put(LoginController.new),
    ),
    GetPage(
      name: otpVerification,
      page: () => const  OtpVerificationScreen(),
      binding: BindingsBuilder.put(OtpController.new),
    ),
    GetPage(
      name: location,
      page: () => LocationScreen(),
      binding: BindingsBuilder.put(LocationController.new),
    ),
    GetPage(
      name: confirmlocation,
      page: () => ConfirmLocationScreen(),
      binding: BindingsBuilder.put(LocationConfirmController.new),
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      binding: BindingsBuilder.put(HomeController.new),
    ),
    
  ];
}
