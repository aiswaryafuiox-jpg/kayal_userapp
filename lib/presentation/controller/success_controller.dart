import 'package:get/get.dart';

class SuccessController extends GetxController {
  final orderId = ''.obs;
  final customOrderId = ''.obs;
  final estimatedDelivery = '25 - 35 Minutes'.obs;
  final totalAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      orderId.value = args['order_id']?.toString() ?? '';
      customOrderId.value = args['custom_order_id']?.toString() ??
          args['order_number']?.toString() ??
          orderId.value;
      
      final rawEst = args['estimated_delivery']?.toString();
      if (rawEst != null && rawEst.trim().isNotEmpty) {
        estimatedDelivery.value = rawEst.trim();
      }

      if (args['total_amount'] != null) {
        if (args['total_amount'] is num) {
          totalAmount.value = (args['total_amount'] as num).toDouble();
        } else {
          totalAmount.value = double.tryParse(args['total_amount'].toString()) ?? 0.0;
        }
      }

      if (args['data'] != null && args['data'] is Map) {
        final dataMap = args['data'] as Map;
        if (customOrderId.value.isEmpty) {
          customOrderId.value = dataMap['custom_order_id']?.toString() ??
              dataMap['order_id']?.toString() ??
              '';
        }
        if (dataMap['estimated_delivery'] != null &&
            dataMap['estimated_delivery'].toString().trim().isNotEmpty) {
          estimatedDelivery.value = dataMap['estimated_delivery'].toString().trim();
        }
      }
    }
  }

  void trackOrder() {
    Get.toNamed('/trackOrder', arguments: {
      'order_id': orderId.value,
      'custom_order_id': customOrderId.value,
      'estimated_delivery': estimatedDelivery.value,
      'total_amount': totalAmount.value,
    });
  }

  void goHome() {
    Get.offAllNamed('/home');
  }
}
