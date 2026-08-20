import 'package:get/get.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';

class OrderDeliveredSuccessController extends GetxController {
  void addTips() {
    Get.toNamed(AppRoutes.addTip);
  }
  void skipForNow() {
    Get.toNamed(AppRoutes.ratings);
  }
}
