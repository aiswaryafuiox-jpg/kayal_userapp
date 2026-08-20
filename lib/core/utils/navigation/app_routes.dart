import 'package:get/get.dart';
import 'package:kayal_userapp/presentation/controller/auth/confirm_location_controller.dart';
import 'package:kayal_userapp/presentation/controller/auth/location_controller.dart';
import 'package:kayal_userapp/presentation/controller/auth/login_controller.dart';
import 'package:kayal_userapp/presentation/controller/auth/otp_controller.dart';
import 'package:kayal_userapp/presentation/controller/auth/signin_controller.dart';
import 'package:kayal_userapp/presentation/controller/auth/verification_success_controller.dart';
import 'package:kayal_userapp/presentation/controller/auth/notification_update_controller.dart';
import 'package:kayal_userapp/presentation/controller/category_controller.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';
import 'package:kayal_userapp/presentation/controller/popular_near_you_controller.dart';
import 'package:kayal_userapp/presentation/controller/onboarding_controller.dart';
import 'package:kayal_userapp/presentation/controller/product_controller.dart';
import 'package:kayal_userapp/presentation/controller/product_detail_controller.dart';
import 'package:kayal_userapp/presentation/controller/splash_controller.dart';
import 'package:kayal_userapp/presentation/view/auth/login/confirm_location_screen.dart';
import 'package:kayal_userapp/presentation/view/auth/login/location_screen.dart';
import 'package:kayal_userapp/presentation/view/auth/login/login_screen.dart';
import 'package:kayal_userapp/presentation/view/auth/login/otp_verification_screen.dart';
import 'package:kayal_userapp/presentation/view/auth/login/verification_success_screen.dart';
import 'package:kayal_userapp/presentation/view/auth/login/notification_update_screen.dart';
import 'package:kayal_userapp/presentation/view/auth/signin/signin_screen.dart';
import 'package:kayal_userapp/presentation/view/home/homescreen.dart';
import 'package:kayal_userapp/presentation/view/home/popular_near_you_screen.dart';
import 'package:kayal_userapp/presentation/view/onboarding/onboarding_screen.dart';
import 'package:kayal_userapp/presentation/view/category/category_screen.dart';
import 'package:kayal_userapp/presentation/view/product/product_screen.dart';
import 'package:kayal_userapp/presentation/view/product_detail/product_detail_screen.dart';
import 'package:kayal_userapp/presentation/view/order_summary/order_summary_screen.dart';
import 'package:kayal_userapp/presentation/controller/order_summary_controller.dart';
import 'package:kayal_userapp/presentation/view/checkout/checkout_screen.dart';
import 'package:kayal_userapp/presentation/controller/checkout_controller.dart';
import 'package:kayal_userapp/presentation/view/checkout/add_address_screen.dart';
import 'package:kayal_userapp/presentation/controller/add_address_controller.dart';
import 'package:kayal_userapp/presentation/view/checkout/payment_method_screen.dart';
import 'package:kayal_userapp/presentation/controller/payment_method_controller.dart';
import 'package:kayal_userapp/presentation/view/checkout/success_screen.dart';
import 'package:kayal_userapp/presentation/controller/success_controller.dart';
import 'package:kayal_userapp/presentation/view/track_order/track_order_screen.dart';
import 'package:kayal_userapp/presentation/controller/track_order_controller.dart';
import 'package:kayal_userapp/presentation/view/checkout/add_tip_screen.dart';
import 'package:kayal_userapp/presentation/controller/add_tip_controller.dart';
import 'package:kayal_userapp/presentation/view/splash/splash_screen.dart';
import 'package:kayal_userapp/presentation/view/track_order/live_tracking_screen.dart';
import 'package:kayal_userapp/presentation/controller/live_tracking_controller.dart';
import 'package:kayal_userapp/presentation/view/track_order/order_delivered_success_screen.dart';
import 'package:kayal_userapp/presentation/controller/order_delivered_success_controller.dart';
import 'package:kayal_userapp/presentation/view/track_order/ratings_screen.dart';
import 'package:kayal_userapp/presentation/controller/ratings_controller.dart';

import 'package:kayal_userapp/presentation/view/wishlist/wishlist_screen.dart';
import 'package:kayal_userapp/presentation/view/track_order/orders_screen.dart';
import 'package:kayal_userapp/presentation/controller/orders_controller.dart';
import 'package:kayal_userapp/presentation/view/cart/cart_screen.dart';
import 'package:kayal_userapp/presentation/view/notification/notification_screen.dart';
import 'package:kayal_userapp/presentation/controller/notification_controller.dart';
import 'package:kayal_userapp/presentation/view/feedback/feedback_screen.dart';
import 'package:kayal_userapp/presentation/controller/feedback_controller.dart';
import 'package:kayal_userapp/presentation/view/profile/help_support_screen.dart';
import 'package:kayal_userapp/presentation/controller/help_support_controller.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String signin = '/signin';
  static const String login = '/login';
  static const String otpVerification = '/otpVerification';
  static const String verificationSuccess = '/verification-success';
  static const String location = '/location';
  static const String confirmlocation = '/confirmlocation';
  static const String notificationUpdate = '/notification-update';
  static const String home = '/home';
  static const String popularNearYou = '/popular-near-you';
  static const String category = '/category';
  static const String product = '/product';
  static const String productDetail = '/productDetail';
  static const String orderSummary = '/orderSummary';
  static const String checkout = '/checkout';
  static const String addAddress = '/addAddress';
  static const String paymentMethod = '/paymentMethod';
  static const String success = '/success';
  static const String trackOrder = '/trackOrder';
  static const String addTip = '/addTip';
  static const String liveTracking = '/liveTracking';
  static const String wishlist = '/wishlist';
  static const String orders = '/orders';
  static const String cart = '/cart';
  static const String notifications = '/notifications';
  static const String feedback = '/feedback';
  static const String helpSupport = '/helpSupport';
  static const String orderDeliveredSuccess = '/orderDeliveredSuccess';
  static const String ratings = '/ratings';

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
      name: signin,
      page: () => SignupScreen(),
      binding: BindingsBuilder.put(SignupController.new),
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
      name: verificationSuccess,
      page: () => const VerificationSuccessScreen(),
      binding: BindingsBuilder.put(VerificationSuccessController.new),
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
      name: notificationUpdate,
      page: () => NotificationUpdateScreen(),
      binding: BindingsBuilder.put(NotificationUpdateController.new),
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      binding: BindingsBuilder.put(HomeController.new),
    ),
    GetPage(
      name: popularNearYou,
      page: () => PopularNearYouScreen(),
      binding: BindingsBuilder.put(PopularNearYouController.new),
    ),
    GetPage(
      name: category,
      page: () => CategoryScreen(),
      binding: BindingsBuilder.put(CategoryController.new),
    ),
    GetPage(
      name: product,
      page: () => ProductScreen(),
      binding: BindingsBuilder.put(ProductController.new),
    ),
    GetPage(
      name: productDetail,
      page: () => ProductDetailScreen(),
      binding: BindingsBuilder.put(ProductDetailController.new),
    ),
    GetPage(
      name: orderSummary,
      page: () => OrderSummaryScreen(),
      binding: BindingsBuilder.put(OrderSummaryController.new),
    ),
    GetPage(
      name: checkout,
      page: () => CheckoutScreen(),
      binding: BindingsBuilder.put(CheckoutController.new),
    ),
    GetPage(
      name: addAddress,
      page: () => AddAddressScreen(),
      binding: BindingsBuilder.put(AddAddressController.new),
    ),
    GetPage(
      name: paymentMethod,
      page: () => PaymentMethodScreen(),
      binding: BindingsBuilder.put(PaymentMethodController.new),
    ),
    GetPage(
      name: success,
      page: () => SuccessScreen(),
      binding: BindingsBuilder.put(SuccessController.new),
    ),
    GetPage(
      name: trackOrder,
      page: () => TrackOrderScreen(),
      binding: BindingsBuilder.put(TrackOrderController.new),
    ),
    GetPage(
      name: addTip,
      page: () => AddTipScreen(),
      binding: BindingsBuilder.put(AddTipController.new),
    ),
    GetPage(
      name: liveTracking,
      page: () => LiveTrackingScreen(),
      binding: BindingsBuilder.put(LiveTrackingController.new),
    ),
    GetPage(
      name: orderDeliveredSuccess,
      page: () => OrderDeliveredSuccessScreen(),
      binding: BindingsBuilder.put(OrderDeliveredSuccessController.new),
    ),
    GetPage(
      name: ratings,
      page: () => RatingsScreen(),
      binding: BindingsBuilder.put(RatingsController.new),
    ),
    GetPage(
      name: wishlist,
      page: () => const WishlistScreen(showBackButton: true),
    ),
    GetPage(
      name: orders,
      page: () => const OrdersScreen(showBackButton: true),
      binding: BindingsBuilder.put(OrdersController.new),
    ),
    GetPage(
      name: cart,
      page: () => CartScreen(),
    ),
    GetPage(
      name: notifications,
      page: () => NotificationScreen(),
      binding: BindingsBuilder.put(NotificationController.new),
    ),
    GetPage(
      name: feedback,
      page: () => FeedbackScreen(),
      binding: BindingsBuilder.put(FeedbackController.new),
    ),
    GetPage(
      name: helpSupport,
      page: () => HelpSupportScreen(),
      binding: BindingsBuilder.put(HelpSupportController.new),
    ),
  ];
}
