import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/initiate_payment_response_model.dart';
import 'package:kayal_userapp/data/repository/initiate_payment_repository_impl.dart';
import 'package:kayal_userapp/data/repository/place_order_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/initiate_payment_usecase.dart';
import 'package:kayal_userapp/domain/usecase/place_order_usecase.dart';
import 'package:kayal_userapp/presentation/controller/cart_controller.dart';

class PaymentMethodController extends GetxController {
  final PlaceOrderUseCase _placeOrderUseCase;
  final InitiatePaymentUseCase _initiatePaymentUseCase;

  PaymentMethodController({
    PlaceOrderUseCase? placeOrderUseCase,
    InitiatePaymentUseCase? initiatePaymentUseCase,
  })  : _placeOrderUseCase = placeOrderUseCase ??
            (sl.isRegistered<PlaceOrderUseCase>()
                ? sl<PlaceOrderUseCase>()
                : PlaceOrderUseCase(
                    PlaceOrderRepositoryImpl(ApiService()))),
        _initiatePaymentUseCase = initiatePaymentUseCase ??
            (sl.isRegistered<InitiatePaymentUseCase>()
                ? sl<InitiatePaymentUseCase>()
                : InitiatePaymentUseCase(
                    InitiatePaymentRepositoryImpl(ApiService())));

  final selectedMethodIndex = 1.obs; // Default to Cash on delivery based on mockup
  final isLoading = false.obs;
  dynamic addressId;
  dynamic orderAmount;

  final paymentMethods = [
    {
      'title': 'Online Transaction',
      'icon': 'online',
      'key': 'online',
    },
    {
      'title': 'Cash on delivery',
      'icon': 'cod',
      'key': 'cash_on_delivery',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is Map) {
      final rawId = arguments['address_id'] ?? arguments['id'];
      addressId = _parseIntegerId(rawId);
      orderAmount = arguments['amount'] ?? arguments['total_amount'];
    }
  }

  dynamic _parseIntegerId(dynamic rawId) {
    if (rawId == null) return null;
    if (rawId is num) return rawId.toInt();
    final str = rawId.toString().trim();
    final parsed = int.tryParse(str);
    if (parsed != null) return parsed;
    final match = RegExp(r'\d+').firstMatch(str);
    if (match != null) {
      return int.tryParse(match.group(0)!) ?? rawId;
    }
    return rawId;
  }

  void selectMethod(int index) {
    if (index >= 0 && index < paymentMethods.length) {
      selectedMethodIndex.value = index;
    }
  }

  String get currentPaymentMethodKey {
    if (selectedMethodIndex.value >= 0 &&
        selectedMethodIndex.value < paymentMethods.length) {
      return paymentMethods[selectedMethodIndex.value]['key'] ?? 'cash_on_delivery';
    }
    return 'cash_on_delivery';
  }

  Future<InitiatePaymentResponseModel?> initiateOnlinePayment({
    required dynamic orderId,
    required dynamic amount,
  }) async {
    try {
      final response = await _initiatePaymentUseCase(
        orderId: orderId,
        amount: amount,
      );
      return response;
    } catch (e) {
      debugPrint('Error initiating payment: $e');
      return null;
    }
  }

  Future<void> payNow() async {
    final targetAddressId = _parseIntegerId(addressId) ?? 1;

    isLoading.value = true;

    try {
      final response = await _placeOrderUseCase(
        addressId: targetAddressId,
        paymentMethod: currentPaymentMethodKey,
      );

      if (response.success) {
        // If Online Transaction is selected, trigger initiate_payment for the placed order
        if (currentPaymentMethodKey == 'online' && response.orderId != null) {
          final paymentResponse = await initiateOnlinePayment(
            orderId: response.orderId,
            amount: orderAmount ?? '540',
          );

          if (paymentResponse != null && !paymentResponse.success) {
            debugPrint('Payment gateway note: ${paymentResponse.formattedErrorMessage}');
          }
        }

        // Clear or refresh cart if available
        if (Get.isRegistered<CartController>()) {
          try {
            final cartController = Get.find<CartController>();
            cartController.cartItems.clear();
          } catch (_) {}
        }

        Get.offAllNamed(
          AppRoutes.success,
          arguments: {
            'order_id': response.orderId,
            'custom_order_id': response.customOrderId ?? response.orderNumber,
            'order_number': response.orderNumber,
            'total_amount': response.totalAmount,
            'estimated_delivery': response.estimatedDelivery,
            'payment_status': response.paymentStatus,
            'status': response.status,
            'data': response.data?.toJson(),
          },
        );
      } else {
        Get.snackbar(
          'Order Failed',
          response.formattedErrorMessage.isNotEmpty
              ? response.formattedErrorMessage
              : 'Failed to place order. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
