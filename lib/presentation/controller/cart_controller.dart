import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';

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

  void proceedToCheckout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Cart Empty',
        'Please add items to cart before proceeding.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.toNamed(AppRoutes.orderSummary);
  }
}
