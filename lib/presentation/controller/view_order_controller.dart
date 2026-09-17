import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/get_order_details_response_model.dart';
import 'package:kayal_userapp/data/model/get_orders_response_model.dart';
import 'package:kayal_userapp/data/repository/get_order_details_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/get_order_details_usecase.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';
import 'package:kayal_userapp/presentation/controller/orders_controller.dart';
import 'package:kayal_userapp/presentation/view/track_order/view_order_screen.dart';

class ViewOrderController extends GetxController {
  final GetOrderDetailsUseCase _getOrderDetailsUseCase;

  ViewOrderController({GetOrderDetailsUseCase? getOrderDetailsUseCase})
      : _getOrderDetailsUseCase = getOrderDetailsUseCase ??
            (sl.isRegistered<GetOrderDetailsUseCase>()
                ? sl<GetOrderDetailsUseCase>()
                : GetOrderDetailsUseCase(
                    GetOrderDetailsRepositoryImpl(ApiService())));

  final orderDetails = Rxn<OrderDetailsDataModel>();
  final orderItemsList = <OrderDetailsItemModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final orderId = '#1025'.obs;
  final orderDate = 'Today 10:30 PM'.obs;
  final orderTotal = 180.obs;
  final orderStatus = 'In Progress'.obs;

  // Single Item Fallback
  final itemName = 'Pineapple Juice'.obs;
  final itemIsVeg = true.obs;
  final itemOriginalPrice = 180.obs;
  final itemDiscountPrice = 180.obs;
  final itemQty = 1.obs;
  final itemImage = productImg1;
  final itemImageUrl = ''.obs;

  // Delivery Address
  final addressType = 'Home'.obs;
  final addressDetails = '123, Barathi Street, T. Nagar'.obs;

  // Order Summary
  final itemTotalAmount = 180.obs;
  final deliveryChargeAmount = 0.obs;
  final totalPaidAmount = 180.obs;

  // Payment Details
  final paymentMethod = 'Paid online'.obs;
  final paymentType = 'UPI / Card'.obs;
  final paymentStatus = 'Paid'.obs;
  final paymentAmount = 180.obs;

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
    dynamic targetOrderId;

    if (args is UserOrderItemModel) {
      targetOrderId = args.orderId;
      orderId.value = args.orderId.startsWith('#') ? args.orderId : '#${args.orderId}';
      orderDate.value = args.date;
      orderTotal.value = args.totalAmount.toInt();
      itemName.value = args.productName;
      itemIsVeg.value = args.isVeg;
      orderStatus.value = args.displayStatus;
      itemDiscountPrice.value = args.totalAmount.toInt();
      itemOriginalPrice.value = args.totalAmount.toInt();
      itemTotalAmount.value = args.totalAmount.toInt();
      totalPaidAmount.value = args.totalAmount.toInt();
      paymentAmount.value = args.totalAmount.toInt();
      if (args.imageUrl != null && args.imageUrl!.isNotEmpty) {
        itemImageUrl.value = args.imageUrl!;
      }
      if (args.isOutForDelivery || args.isDelivered || args.isCancelled) {
        isCancellationUnavailable.value = args.isOutForDelivery || args.isDelivered;
      }
    } else if (args is OrderItem) {
      targetOrderId = args.orderId;
      orderId.value = args.orderId.isNotEmpty
          ? (args.orderId.startsWith('#') ? args.orderId : '#${args.orderId}')
          : '#1025';
      orderDate.value = args.datetime;
      orderTotal.value = args.price.toInt();
      itemName.value = args.title;
      itemIsVeg.value = args.isVeg;
      orderStatus.value = args.status;
      itemDiscountPrice.value = args.price.toInt();
      itemOriginalPrice.value = args.price.toInt();
      itemTotalAmount.value = args.price.toInt();
      totalPaidAmount.value = args.price.toInt();
      paymentAmount.value = args.price.toInt();
      if (args.imageUrl != null && args.imageUrl!.isNotEmpty) {
        itemImageUrl.value = args.imageUrl!;
      }
      if (args.status.toLowerCase().contains('out of delivery')) {
        isCancellationUnavailable.value = false;
      }
    } else if (args is Map) {
      targetOrderId = args['order_id'] ?? args['id'];
      if (args['status'] != null) {
        orderStatus.value = args['status'].toString();
      }
    } else if (args != null) {
      targetOrderId = args.toString();
    }

    if (targetOrderId != null && targetOrderId.toString().isNotEmpty) {
      fetchOrderDetails(targetOrderId);
    }
  }

  Future<void> fetchOrderDetails(dynamic id) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _getOrderDetailsUseCase(orderId: id);
      if (response.success && response.data != null) {
        final data = response.data!;
        orderDetails.value = data;
        orderItemsList.assignAll(data.items);

        orderId.value = data.customOrderId.isNotEmpty
            ? data.customOrderId
            : (data.orderId.startsWith('#') ? data.orderId : '#${data.orderId}');

        if (data.orderDate.isNotEmpty) {
          orderDate.value = data.orderDate;
        }

        if (data.items.isNotEmpty) {
          final first = data.items.first;
          itemName.value = first.name;
          itemIsVeg.value = first.isVeg;
          itemOriginalPrice.value = first.mrp.toInt();
          itemDiscountPrice.value = first.sellPrice.toInt();
          itemQty.value = first.qty;
          if (first.imageUrl != null && first.imageUrl!.isNotEmpty) {
            itemImageUrl.value = first.imageUrl!;
          }
        }

        if (data.deliveryAddress != null) {
          addressType.value = data.deliveryAddress!.addressType;
          addressDetails.value = data.deliveryAddress!.displayAddress;
        }

        if (data.summary != null) {
          itemTotalAmount.value = data.summary!.itemTotal.toInt();
          totalPaidAmount.value = data.summary!.grandTotal.toInt();
          orderTotal.value = data.summary!.grandTotal.toInt();
          paymentAmount.value = data.summary!.grandTotal.toInt();
        }

        if (data.paymentDetails != null) {
          paymentMethod.value = data.paymentDetails!.displayMethod;
          paymentStatus.value = data.paymentDetails!.displayStatus;
        }
      } else {
        errorMessage.value = response.formattedErrorMessage.isNotEmpty
            ? response.formattedErrorMessage
            : 'Failed to fetch order details';
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
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
