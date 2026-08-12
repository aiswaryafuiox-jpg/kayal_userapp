import 'package:get/get.dart';

class PaymentMethodController extends GetxController {
  final selectedMethodIndex = 1.obs; // Default to Cash on delivery based on mockup

  final paymentMethods = [
    {
      'title': 'Online Transaction',
      'icon': 'online',
    },
    {
      'title': 'Cash on delivery',
      'icon': 'cod',
    },
  ].obs;

  void selectMethod(int index) {
    selectedMethodIndex.value = index;
  }

  void payNow() {
    Get.offAllNamed('/success');
  }
}
