import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/get_orders_response_model.dart';
import 'package:kayal_userapp/data/repository/get_orders_repository_impl.dart';
import 'package:kayal_userapp/data/repository/re_order_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/get_orders_usecase.dart';
import 'package:kayal_userapp/domain/usecase/re_order_usecase.dart';
import 'package:kayal_userapp/presentation/controller/cart_controller.dart';
import 'package:kayal_userapp/presentation/view/track_order/view_order_screen.dart';

// Backward compatibility class for other screens if needed
class OrderItem {
  final String orderId;
  final String title;
  final String type;
  final bool isVeg;
  final String datetime;
  final double price;
  final String status;
  final String image;
  final String? imageUrl;

  OrderItem({
    this.orderId = '',
    required this.title,
    required this.type,
    required this.isVeg,
    required this.datetime,
    required this.price,
    required this.status,
    this.image = productImg1,
    this.imageUrl,
  });

  factory OrderItem.fromUserModel(UserOrderItemModel model) {
    return OrderItem(
      orderId: model.orderId,
      title: model.productName,
      type: model.type,
      isVeg: model.isVeg,
      datetime: model.date,
      price: model.totalAmount,
      status: model.displayStatus,
      image: productImg1,
      imageUrl: model.imageUrl,
    );
  }
}

class OrdersController extends GetxController {
  final GetOrdersUseCase _getOrdersUseCase;
  final ReOrderUseCase _reOrderUseCase;

  OrdersController({
    GetOrdersUseCase? getOrdersUseCase,
    ReOrderUseCase? reOrderUseCase,
  })  : _getOrdersUseCase = getOrdersUseCase ??
            (sl.isRegistered<GetOrdersUseCase>()
                ? sl<GetOrdersUseCase>()
                : GetOrdersUseCase(GetOrdersRepositoryImpl(ApiService()))),
        _reOrderUseCase = reOrderUseCase ??
            (sl.isRegistered<ReOrderUseCase>()
                ? sl<ReOrderUseCase>()
                : ReOrderUseCase(ReOrderRepositoryImpl(ApiService())));

  final ordersList = <UserOrderItemModel>[].obs;
  final isLoading = false.obs;
  final isReordering = false.obs;
  final errorMessage = ''.obs;
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatusAndFetch();
  }

  Future<void> checkLoginStatus() async {
    await checkLoginStatusAndFetch();
  }

  Future<void> checkLoginStatusAndFetch() async {
    isLoggedIn.value = LocalStorageService().isLoggedIn();

    if (isLoggedIn.value) {
      await fetchOrders();
    } else {
      ordersList.clear();
    }
  }

  Future<void> fetchOrders({bool isRefresh = false}) async {
    if (!isRefresh) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await _getOrdersUseCase(page: 1);
      if (response.success) {
        final completeOrders =
            response.orders.where((order) => !order.isIncomplete).toList();
        ordersList.assignAll(completeOrders);
      } else {
        errorMessage.value = response.formattedErrorMessage.isNotEmpty
            ? response.formattedErrorMessage
            : 'Failed to load orders';
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void viewOrderDetails(UserOrderItemModel order) {
    Get.to(() => const ViewOrderScreen(), arguments: order);
  }

  Future<void> reOrder(UserOrderItemModel order) async {
    isReordering.value = true;
    try {
      Get.snackbar(
        'Re-Ordering',
        'Adding items from order #${order.orderId} to cart...',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      final response = await _reOrderUseCase(orderId: order.orderId);
      if (response.success) {
        if (Get.isRegistered<CartController>()) {
          Get.find<CartController>().fetchCart();
        }

        Get.snackbar(
          'Added to Cart',
          response.message.isNotEmpty
              ? response.message
              : 'Items added to cart successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF2E7D32),
          colorText: Colors.white,
          mainButton: TextButton(
            onPressed: () => Get.toNamed(AppRoutes.cart),
            child: const Text(
              'VIEW CART',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else {
        Get.snackbar(
          'Re-Order Failed',
          response.formattedErrorMessage.isNotEmpty
              ? response.formattedErrorMessage
              : 'Failed to re-order items.',
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
      isReordering.value = false;
    }
  }
}
