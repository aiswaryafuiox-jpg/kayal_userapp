import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItemModel {
  final String id;
  final String name;
  final String type;
  final bool isVeg;
  final double oldPrice;
  final double newPrice;
  final String discount;
  final String image;
  final RxInt quantity;

  CartItemModel({
    required this.id,
    required this.name,
    required this.type,
    required this.isVeg,
    required this.oldPrice,
    required this.newPrice,
    this.discount = '20 %',
    required this.image,
    int quantity = 1,
  }) : quantity = quantity.obs;
}

class CartController extends GetxController {
  final cartItems = <CartItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialItems();
  }

  void _loadInitialItems() {
    cartItems.assignAll([
      CartItemModel(
        id: '1',
        name: 'The Spice Pizza',
        type: 'Veg',
        isVeg: true,
        oldPrice: 200,
        newPrice: 150,
        discount: '20 %',
        image: productImg3,
        quantity: 1,
      ),
      CartItemModel(
        id: '2',
        name: 'The Spice Pizza',
        type: 'Veg',
        isVeg: true,
        oldPrice: 200,
        newPrice: 150,
        discount: '20 %',
        image: productImg3,
        quantity: 1,
      ),
      CartItemModel(
        id: '3',
        name: 'The Spice Pizza',
        type: 'Veg',
        isVeg: true,
        oldPrice: 200,
        newPrice: 150,
        discount: '20 %',
        image: productImg3,
        quantity: 1,
      ),
    ]);
  }

  void addItem({
    required String id,
    required String name,
    required String type,
    required bool isVeg,
    required double oldPrice,
    required double newPrice,
    required String image,
    int quantity = 1,
  }) {
    final index = cartItems.indexWhere((item) => item.name == name);
    if (index != -1) {
      cartItems[index].quantity.value += quantity;
    } else {
      cartItems.add(
        CartItemModel(
          id: id,
          name: name,
          type: type,
          isVeg: isVeg,
          oldPrice: oldPrice,
          newPrice: newPrice,
          image: image,
          quantity: quantity,
        ),
      );
    }
    Get.snackbar(
      'Cart',
      '$name added to cart.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFFFEBDC),
      colorText: const Color(0xFF1F2937),
    );
  }

  void incrementQuantity(int index) {
    cartItems[index].quantity.value++;
  }

  void decrementQuantity(int index) {
    if (cartItems[index].quantity.value > 1) {
      cartItems[index].quantity.value--;
    } else {
      removeItem(index);
    }
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
  }

  double get totalAmount {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + (item.newPrice * item.quantity.value),
    );
  }

  Future<void> proceedToCheckout() async {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Cart Empty',
        'Please add items to cart before proceeding.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    
    if (isLoggedIn) {
      Get.toNamed(AppRoutes.orderSummary);
    } else {
      Get.toNamed(
        AppRoutes.login,
        arguments: {'redirect': AppRoutes.orderSummary},
      );
    }
  }
}
