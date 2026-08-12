import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      Get.snackbar('Success', 'Address saved successfully');
      Get.back();
    }
  }
}
