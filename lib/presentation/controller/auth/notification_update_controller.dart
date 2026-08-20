import 'package:get/get.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';

class NotificationUpdateController extends GetxController {
  final isLoading = false.obs;

  void onContinue() {
    Get.offAllNamed(AppRoutes.home);
  }

  void onNotNow() {
    Get.offAllNamed(AppRoutes.home);
  }
}
