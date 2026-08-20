import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';

class ProductController extends GetxController {
  final products = <ProductModel>[].obs;
  final isRestaurantClosed = false.obs;
  final closedNotes =
      'This restaurant is currently unavailable.\nOpens today at 10:00 AM'.obs;

  @override
  void onInit() {
    super.onInit();
    updateArguments(Get.arguments);
    _loadProducts();
  }

  void updateArguments([dynamic args]) {
    final currentArgs = args ?? Get.arguments;
    if (currentArgs != null) {
      if (currentArgs is RestaurantItem) {
        isRestaurantClosed.value = !currentArgs.isOpen;
        if (!currentArgs.isOpen) {
          closedNotes.value =
              'This restaurant is currently unavailable.\n${currentArgs.openingTime}';
        }
      } else if (currentArgs is Map) {
        if (currentArgs['isClosed'] != null) {
          isRestaurantClosed.value = currentArgs['isClosed'] == true;
        }
        if (currentArgs['notes'] != null) {
          closedNotes.value = currentArgs['notes'];
        }
        if (currentArgs['restaurant'] != null &&
            currentArgs['restaurant'] is RestaurantItem) {
          final RestaurantItem r = currentArgs['restaurant'];
          isRestaurantClosed.value = !r.isOpen;
          if (!r.isOpen) {
            closedNotes.value =
                'This restaurant is currently unavailable.\n${r.openingTime}';
          }
        }
      }
    }
  }

  void _loadProducts() {
    products.assignAll([
      ProductModel(
        id: '1',
        name: 'Veg Chilly Pizza',
        type: 'Veg',
        isVeg: true,
        oldPrice: 200,
        newPrice: 150,
        image: productImg1,
      ),
      ProductModel(
        id: '2',
        name: 'Chicken Pizza',
        type: 'Non-Veg',
        isVeg: false,
        oldPrice: 200,
        newPrice: 150,
        image: productImg2,
      ),
      ProductModel(
        id: '3',
        name: 'The Spice Pizza',
        type: 'Veg',
        isVeg: true,
        oldPrice: 200,
        newPrice: 150,
        image: productImg3,
      ),
      ProductModel(
        id: '4',
        name: 'The Spice Pizza',
        type: 'Veg',
        isVeg: true,
        oldPrice: 200,
        newPrice: 150,
        image: productImg4,
      ),
      ProductModel(
        id: '5',
        name: 'Mushroom Pizza',
        type: 'Veg',
        isVeg: true,
        oldPrice: 200,
        newPrice: 150,
        image: productImg5,
      ),
      ProductModel(
        id: '6',
        name: 'Corn pizza',
        type: 'Veg',
        isVeg: true,
        oldPrice: 200,
        newPrice: 150,
        image: productImg6,
      ),
    ]);
  }

  void toggleFavorite(String id) {
    final index = products.indexWhere((p) => p.id == id);
    if (index != -1) {
      final product = products[index];
      product.isFavorite.value = !product.isFavorite.value;
    }
  }

  void addToCart(String id) {
    if (isRestaurantClosed.value) {
      Get.snackbar(
        'Restaurant Unavailable',
        'Cannot add items to cart while restaurant is closed.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.snackbar(
      'Cart',
      'Item added to cart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void openFilter() {
    Get.snackbar(
      'Filter',
      'Filter clicked',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void viewCart() {
    Get.toNamed(AppRoutes.cart);
  }
}

class ProductModel {
  final String id;
  final String name;
  final String type;
  final bool isVeg;
  final double oldPrice;
  final double newPrice;
  final String image;
  RxBool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.type,
    required this.isVeg,
    required this.oldPrice,
    required this.newPrice,
    required this.image,
    bool isFavorite = false,
  }) : isFavorite = isFavorite.obs;
}
