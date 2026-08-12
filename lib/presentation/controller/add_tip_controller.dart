import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/presentation/controller/track_order_controller.dart';

class AddTipController extends GetxController {
  final selectedTip = Rxn<int>();
  final customTipController = TextEditingController();

  final tipOptions = [20, 30, 50, 100];

  @override
  void onClose() {
    customTipController.dispose();
    super.onClose();
  }

  void selectTip(int amount) {
    selectedTip.value = amount;
    customTipController.clear();
  }

  void onCustomTipChanged(String value) {
    if (value.isNotEmpty) {
      selectedTip.value = null; // Clear predefined selection if user types
    }
  }

  void continueToNext() {
    final tip = selectedTip.value ?? (int.tryParse(customTipController.text) ?? 0);
    if (tip > 0) {
      Get.snackbar('Tip Added', '\$$tip added as tip for the delivery partner');
    } else {
      Get.snackbar('Info', 'Proceeding without a tip');
    }
    
    // Safely update the TrackOrderController if it exists
    if (Get.isRegistered<TrackOrderController>()) {
      Get.find<TrackOrderController>().tipAmount.value = tip;
    }

    // Unconditionally go to Track Order Screen with a forward navigation
    Get.toNamed('/trackOrder', arguments: {'tip': tip});
  }
}
