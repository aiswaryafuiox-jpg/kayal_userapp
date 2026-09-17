import 'package:get/get.dart';

class TrackOrderController extends GetxController {
  final tipAmount = 0.obs;
  final orderId = ''.obs;
  final customOrderId = 'OID006'.obs;
  final estimatedDelivery = '25 - 35 Minutes'.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      if (args['tip'] != null) {
        tipAmount.value = args['tip'] as int;
      }
      if (args['order_id'] != null) {
        orderId.value = args['order_id'].toString();
      }
      if (args['custom_order_id'] != null &&
          args['custom_order_id'].toString().trim().isNotEmpty) {
        customOrderId.value = args['custom_order_id'].toString().trim();
      } else if (orderId.value.isNotEmpty) {
        customOrderId.value = '#${orderId.value}';
      }
      if (args['estimated_delivery'] != null &&
          args['estimated_delivery'].toString().trim().isNotEmpty) {
        estimatedDelivery.value = args['estimated_delivery'].toString().trim();
      }
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
