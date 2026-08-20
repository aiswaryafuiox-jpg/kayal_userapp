import 'package:get/get.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';
import 'package:kayal_userapp/presentation/controller/product_controller.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailController extends GetxController {
  final quantity = 1.obs;
  final isFavorite = false.obs;
  final isRestaurantClosed = false.obs;
  final closedNotes =
      'This restaurant is currently unavailable.\nOpens today at 10:00 AM'.obs;
  final Rxn<ProductModel> product = Rxn<ProductModel>();

  @override
  void onInit() {
    super.onInit();
    updateArguments(Get.arguments);
  }

  void updateArguments([dynamic args]) {
    final currentArgs = args ?? Get.arguments;
    if (currentArgs != null) {
      if (currentArgs is Map) {
        if (currentArgs['isClosed'] != null) {
          isRestaurantClosed.value = currentArgs['isClosed'] == true;
        }
        if (currentArgs['notes'] != null) {
          closedNotes.value = currentArgs['notes'];
        }
        if (currentArgs['product'] != null &&
            currentArgs['product'] is ProductModel) {
          product.value = currentArgs['product'];
        }
      } else if (currentArgs is RestaurantItem) {
        isRestaurantClosed.value = !currentArgs.isOpen;
      }
    }
  }

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
    if (isRestaurantClosed.value) {
      Get.snackbar(
        'Restaurant Unavailable',
        'Cannot add items to cart while restaurant is closed.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.snackbar('Success', 'Item added to cart');
  }

  Future<void> placeOrder() async {
    if (isRestaurantClosed.value) {
      Get.snackbar(
        'Restaurant Closed',
        'Ordering is disabled as this restaurant is currently closed.',
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

  void goBack() {
    Get.back();
  }
}
