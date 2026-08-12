import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';

class ProductController extends GetxController {
  
  final products = <ProductModel>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadProducts();
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
    Get.snackbar(
      'Cart',
      'Navigating to cart...',
      snackPosition: SnackPosition.BOTTOM,
    );
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
