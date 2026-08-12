import 'package:get/get.dart';

class ProductDetailController extends GetxController {
  final quantity = 1.obs;
  final isFavorite = false.obs;

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  void addToCart() {
    // Add to cart logic
    Get.snackbar('Success', 'Item added to cart');
  }

  void placeOrder() {
    Get.toNamed('/orderSummary');
  }

  void goBack() {
    Get.back();
  }
}
