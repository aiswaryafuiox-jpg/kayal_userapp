import 'package:get/get.dart';

class CheckoutController extends GetxController {
  final selectedAddressIndex = 0.obs;

  final addresses = [
    {
      'type': 'Home',
      'address': '123, barathi street\nChennai, Tamil nadu-624001',
    },
    {
      'type': 'Work',
      'address': '123, barathi street\nChennai, Tamil nadu-624001',
    },
  ].obs;

  void selectAddress(int index) {
    selectedAddressIndex.value = index;
  }

  void editAddress(int index) {
    Get.toNamed(
      '/addAddress',
      arguments: {
        'index': index,
        'address': addresses[index],
        'isEdit': true,
      },
    );
  }

  void addNewAddress() {
    Get.toNamed('/addAddress');
  }

  void continuePayment() {
    Get.toNamed('/paymentMethod');
  }

  void goBack() {
    Get.back();
  }
}
