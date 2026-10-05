import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/order_summary_response_model.dart';
import 'package:kayal_userapp/data/repository/order_summary_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/get_order_summary_usecase.dart';
import 'package:kayal_userapp/presentation/controller/cart_controller.dart';
import 'package:kayal_userapp/presentation/controller/product_controller.dart';

class OrderSummaryController extends GetxController {
  final GetOrderSummaryUseCase _getOrderSummaryUseCase;

  OrderSummaryController({GetOrderSummaryUseCase? getOrderSummaryUseCase})
    : _getOrderSummaryUseCase =
          getOrderSummaryUseCase ??
          (sl.isRegistered<GetOrderSummaryUseCase>()
              ? sl<GetOrderSummaryUseCase>()
              : GetOrderSummaryUseCase(
                  OrderSummaryRepositoryImpl(ApiService()),
                ));

  final Rxn<OrderSummaryDataModel> orderSummary = Rxn<OrderSummaryDataModel>();
  final items = <OrderSummaryItemModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString specialInstructions = ''.obs;

  @override
  void onInit() {
    super.onInit();
    updateArguments(Get.arguments);
    fetchOrderSummary();
  }

  void updateArguments([dynamic args]) {
    final currentArgs = args ?? Get.arguments;
    if (currentArgs != null) {
      if (currentArgs is Map) {
        if (currentArgs['product'] != null) {
          final dynamic prod = currentArgs['product'];
          final int qty = (currentArgs['quantity'] is int)
              ? currentArgs['quantity'] as int
              : int.tryParse(currentArgs['quantity']?.toString() ?? '1') ?? 1;

          if (prod is ProductModel) {
            items.assignAll([
              OrderSummaryItemModel(
                id: prod.id,
                productId: prod.id,
                name: prod.name,
                image: prod.image,
                price: prod.newPrice,
                oldPrice: prod.oldPrice,
                quantity: qty,
                type: prod.type,
                isVeg: prod.isVeg,
                totalPrice: prod.newPrice * qty,
              ),
            ]);
          }
        } else if (currentArgs['items'] != null &&
            currentArgs['items'] is List) {
          final list = (currentArgs['items'] as List)
              .whereType<OrderSummaryItemModel>()
              .toList();
          if (list.isNotEmpty) {
            items.assignAll(list);
          }
        }
      }
    }

    // If no direct args, check if active CartController has real items
    if (items.isEmpty && Get.isRegistered<CartController>()) {
      final cartController = Get.find<CartController>();
      if (cartController.cartItems.isNotEmpty) {
        final cartList = cartController.cartItems.map((cartItem) {
          return OrderSummaryItemModel(
            id: cartItem.id,
            productId: cartItem.id,
            name: cartItem.name,
            image: cartItem.image,
            price: cartItem.newPrice,
            oldPrice: cartItem.oldPrice,
            quantity: cartItem.quantity.value,
            type: cartItem.type,
            isVeg: cartItem.isVeg,
            totalPrice: cartItem.newPrice * cartItem.quantity.value,
          );
        }).toList();
        items.assignAll(cartList);
      }
    }
  }

  Future<void> fetchOrderSummary() async {
    try {
      isLoading.value = true;
      final storage = LocalStorageService();
      final sessionId = storage.getOrCreateSessionId();
      final response = await _getOrderSummaryUseCase(sessionId: sessionId);
      if (response.success && response.data != null) {
        orderSummary.value = response.data;
        if (response.data!.items.isNotEmpty) {
          items.assignAll(response.data!.items);
        }
        if (response.data!.specialInstructions != null &&
            response.data!.specialInstructions!.isNotEmpty) {
          specialInstructions.value = response.data!.specialInstructions!;
        }
      }
    } catch (e) {
      debugPrint('fetchOrderSummary error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  double get subTotal {
    if (orderSummary.value != null &&
        orderSummary.value!.subTotal > 0 &&
        (orderSummary.value!.items.isNotEmpty || items.isEmpty)) {
      return orderSummary.value!.subTotal;
    }
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get discount {
    if (orderSummary.value != null &&
        orderSummary.value!.discount > 0 &&
        (orderSummary.value!.items.isNotEmpty || items.isEmpty)) {
      return orderSummary.value!.discount;
    }
    double totalOld = items.fold(
      0.0,
      (sum, item) =>
          sum +
          (item.oldPrice > item.price
              ? item.oldPrice * item.quantity
              : item.price * item.quantity),
    );
    double totalNew = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final diff = totalOld - totalNew;
    return diff > 0 ? diff : 0.0;
  }

  double get deliveryCharge {
    return orderSummary.value?.deliveryCharge ?? 0.0;
  }

  double get totalAmount {
    if (orderSummary.value != null &&
        orderSummary.value!.totalAmount > 0 &&
        (orderSummary.value!.items.isNotEmpty || items.isEmpty)) {
      return orderSummary.value!.totalAmount;
    }
    final calcTotal = subTotal - discount + deliveryCharge;
    return calcTotal > 0 ? calcTotal : subTotal;
  }

  String get estimatedDeliveryTime {
    return orderSummary.value?.estimatedDeliveryTime ?? '20-25 mins';
  }

  void continueToPayment() {
    if (items.isEmpty) {
      Get.snackbar(
        'Order Empty',
        'Please add items before continuing to payment.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final storage = LocalStorageService();
    if (!storage.isLoggedIn()) {
      Get.toNamed(
        AppRoutes.login,
        arguments: {'redirect': AppRoutes.checkout},
      );
      return;
    }

    Get.toNamed(AppRoutes.checkout);
  }

  void addSpecialInstructions() {
    final textController = TextEditingController(
      text: specialInstructions.value,
    );

    Get.defaultDialog(
      title: 'Special Instructions',
      titleStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF252B35),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextField(
          controller: textController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'e.g. Less spicy, extra sauce, leave at door',
            hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFF823E)),
            ),
          ),
        ),
      ),
      textConfirm: 'Save',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFFF823E),
      onConfirm: () {
        specialInstructions.value = textController.text.trim();
        Get.back();
      },
      textCancel: 'Cancel',
      cancelTextColor: const Color(0xFF6B7280),
    );
  }

  void goBack() {
    Get.back();
  }
}
