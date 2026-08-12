import 'package:get/get.dart';

class OrderSummaryController extends GetxController {
  
  void continueToPayment() {
    Get.toNamed('/checkout');
  }

  void addSpecialInstructions() {
    // Navigate or show dialog to add special instructions
    Get.snackbar('Info', 'Add Special Instructions tapped');
  }

  void goBack() {
    Get.back();
  }
}
