import 'package:get/get.dart';

class SuccessController extends GetxController {
  
  void trackOrder() {
    Get.toNamed('/trackOrder');
  }

  void goHome() {
    Get.offAllNamed('/home');
  }
}
