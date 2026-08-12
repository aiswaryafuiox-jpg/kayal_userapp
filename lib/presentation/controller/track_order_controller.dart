import 'package:get/get.dart';

class TrackOrderController extends GetxController {
  final tipAmount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map && Get.arguments['tip'] != null) {
      tipAmount.value = Get.arguments['tip'] as int;
    }
  }
  
  void callRestaurant() {
    Get.snackbar('Calling', 'Calling Saravana Bavan...');
  }

  void addTip() async {
    final result = await Get.toNamed('/addTip');
    if (result != null && result is int && result > 0) {
      tipAmount.value = result;
    }
  }

  void trackLive() {
    Get.toNamed('/liveTracking');
  }
}
