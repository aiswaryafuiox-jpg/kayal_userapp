import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';
import 'package:kayal_userapp/presentation/controller/orders_controller.dart';
import 'package:kayal_userapp/presentation/view/track_order/view_order_screen.dart';

class ViewOrderController extends GetxController {
  final orderId = '#1025'.obs;
  final orderDate = 'Today 10:30 PM'.obs;
  final orderTotal = 180.obs;
  final orderStatus = 'In Progress'.obs; // 'In Progress', 'Out of Delivery', 'Delivered', 'Cancelled'

  // Order Items
  final itemName = 'Chicken Pizza'.obs;
  final itemIsVeg = false.obs;
  final itemOriginalPrice = 220.obs;
  final itemDiscountPrice = 180.obs;
  final itemQty = 2.obs;
  final itemImage = productImg1;

  // Delivery Address
  final addressType = 'Home'.obs;
  final addressDetails = '123, barathi street\nChennai, Tamil nadu-624001'.obs;

  // Order Summary
  final itemTotalAmount = 120.obs;
  final deliveryChargeAmount = 40.obs;
  final totalPaidAmount = 160.obs;

  // Payment Details
  final paymentMethod = 'Paid online'.obs;
  final paymentType = 'UPI . Google Pay'.obs;
  final paymentStatus = 'Paid'.obs;
  final paymentAmount = 220.obs;

  // Cancellation State
  final selectedCancelReason = 'Order by Mistake'.obs;
  final otherReasonTextController = TextEditingController();
  final isCancellationUnavailable = false.obs;

  final cancelReasons = [
    'Order by Mistake',
    'Found better offer',
    'Change in plan',
    'Other Reson',
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is OrderItem) {
      orderId.value = '#1025';
      orderDate.value = args.datetime;
      orderTotal.value = args.price.toInt();
      itemName.value = args.title;
      itemIsVeg.value = args.isVeg;
      orderStatus.value = args.status;
      if (args.status.toLowerCase().contains('out of delivery')) {
        isCancellationUnavailable.value = false; // can toggle or set
      }
    }
  }

  void selectCancelReason(String reason) {
    selectedCancelReason.value = reason;
  }

  void onCancelOrderButtonTap() {
    if (orderStatus.value.toLowerCase() == 'cancelled') {
      Get.snackbar('Order Cancelled', 'This order is already cancelled.');
      return;
    }
    openCancelBottomSheet();
  }

  void openCancelBottomSheet() {
    Get.bottomSheet(
      const CancelOrderBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void proceedCancel() {
    if (selectedCancelReason.value == 'Other Reson' ||
        selectedCancelReason.value == 'Other Reason') {
      Get.back(); // close bottom sheet
      showOtherReasonDialog();
    } else {
      confirmCancellation();
    }
  }

  void showOtherReasonDialog() {
    Get.dialog(
      const OtherReasonDialog(),
      barrierDismissible: false,
    );
  }

  void confirmCancellation() {
    Get.back(); // close dialog or bottomsheet
    isCancellationUnavailable.value = true;
  }

  void backToHome() {
    Get.back(); // close bottom sheet
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().changeBottomIndex(0);
    }
    Get.offAllNamed(AppRoutes.home);
  }

  void openSupport() {
    Get.snackbar(
      'Support',
      'Connecting to customer support...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    otherReasonTextController.dispose();
    super.onClose();
  }
}
