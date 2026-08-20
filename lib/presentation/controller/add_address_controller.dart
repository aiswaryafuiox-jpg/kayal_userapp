import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/presentation/controller/checkout_controller.dart';

class AddAddressController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final pincodeController = TextEditingController();
  final addressController = TextEditingController();
  final landmarkController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final locationTypeController = TextEditingController();

  final isEdit = false.obs;
  int? editIndex;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is Map && arguments['isEdit'] == true) {
      isEdit.value = true;
      editIndex = arguments['index'];
      final addressData = arguments['address'];
      if (addressData is Map) {
        nameController.text = "Lunna";
        phoneController.text = "896745321";
        locationTypeController.text = addressData['type'] ?? '';
        addressController.text = addressData['address'] ?? '';
        cityController.text = "Chennai";
        stateController.text = "Tamil nadu";
        pincodeController.text = "624001";
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    pincodeController.dispose();
    addressController.dispose();
    landmarkController.dispose();
    cityController.dispose();
    stateController.dispose();
    locationTypeController.dispose();
    super.onClose();
  }

  void saveAddress() {
    if (formKey.currentState!.validate()) {
      if (isEdit.value && editIndex != null) {
        if (Get.isRegistered<CheckoutController>()) {
          final checkoutController = Get.find<CheckoutController>();
          checkoutController.addresses[editIndex!] = {
            'type': locationTypeController.text,
            'address': addressController.text,
          };
        }
      }
      Get.snackbar('Success', isEdit.value ? 'Address updated successfully' : 'Address saved successfully');
      Get.back();
    }
  }
}
