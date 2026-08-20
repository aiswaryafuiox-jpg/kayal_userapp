import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';

class EditProfileController extends GetxController {
  final profileImage = profileImg.obs; // Use appropriate image

  // Text Controllers
  final fullNameController = TextEditingController(text: 'Lunaa');
  final phoneController = TextEditingController(text: '+91 98564362789');
  final emailController = TextEditingController(text: 'lunaa@gmail.com');
  final addressController = TextEditingController(
      text: '23, barathi street\nChennai, Tamil nadu-624001');
  final locationTypeController = TextEditingController(text: 'Home');

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    locationTypeController.dispose();
    super.onClose();
  }

  void changePhoto() {
    // Handle photo change logic
  }

  void saveProfile() {
    // Handle save logic
    Get.back();
  }
}
