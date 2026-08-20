import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/presentation/controller/product_controller.dart';
import 'package:kayal_userapp/presentation/controller/product_detail_controller.dart';

class WishlistItem {
  final String title;
  final String type;
  final bool isVeg;
  final double originalPrice;
  final double price;
  final String image;
  bool isFavorite;

  WishlistItem({
    required this.title,
    required this.type,
    required this.isVeg,
    required this.originalPrice,
    required this.price,
    required this.image,
    this.isFavorite = true,
  });
}

class WishlistController extends GetxController {
  final wishlistItems = <WishlistItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  void fetchWishlist() {
    // Simulated data matching the design
    wishlistItems.assignAll([
      WishlistItem(
        title: "The Spice Pizza",
        type: "Veg",
        isVeg: true,
        originalPrice: 200,
        price: 150,
        image: productImg1,
      ),
      WishlistItem(
        title: "The Spice Pizza",
        type: "Veg",
        isVeg: true,
        originalPrice: 200,
        price: 150,
        image: productImg2,
      ),
      WishlistItem(
        title: "The Spice Pizza",
        type: "Veg",
        isVeg: true,
        originalPrice: 200,
        price: 150,
        image: productImg3,
      ),
      WishlistItem(
        title: "The Spice Pizza",
        type: "Veg",
        isVeg: true,
        originalPrice: 200,
        price: 150,
        image: productImg4,
      ),
      WishlistItem(
        title: "The Spice Pizza",
        type: "Veg",
        isVeg: true,
        originalPrice: 200,
        price: 150,
        image: productImg5,
      ),
      WishlistItem(
        title: "The Spice Pizza",
        type: "Veg",
        isVeg: true,
        originalPrice: 200,
        price: 150,
        image: productImg6,
      ),
    ]);
  }

  void toggleFavorite(int index) {
    final item = wishlistItems[index];
    wishlistItems.removeAt(index);

    // Sync with ProductController if registered
    if (Get.isRegistered<ProductController>()) {
      final productController = Get.find<ProductController>();
      final prodIndex = productController.products.indexWhere((p) => p.name == item.title);
      if (prodIndex != -1) {
        productController.products[prodIndex].isFavorite.value = false;
      }
    }

    // Sync with ProductDetailController if registered
    if (Get.isRegistered<ProductDetailController>()) {
      final detailController = Get.find<ProductDetailController>();
      if (detailController.product.value?.name == item.title) {
        detailController.isFavorite.value = false;
      }
    }
  }

  bool isFavorite(String title) {
    return wishlistItems.any((item) => item.title == title);
  }

  void toggleProductFavorite(ProductModel product) {
    final index = wishlistItems.indexWhere((item) => item.title == product.name);
    if (index != -1) {
      wishlistItems.removeAt(index);
      product.isFavorite.value = false;
      
      // Also update ProductDetailController if the active product is this one
      if (Get.isRegistered<ProductDetailController>()) {
        final detailController = Get.find<ProductDetailController>();
        if (detailController.product.value?.name == product.name) {
          detailController.isFavorite.value = false;
        }
      }
    } else {
      wishlistItems.add(
        WishlistItem(
          title: product.name,
          type: product.type,
          isVeg: product.isVeg,
          originalPrice: product.oldPrice,
          price: product.newPrice,
          image: product.image,
          isFavorite: true,
        ),
      );
      product.isFavorite.value = true;

      // Also update ProductDetailController if the active product is this one
      if (Get.isRegistered<ProductDetailController>()) {
        final detailController = Get.find<ProductDetailController>();
        if (detailController.product.value?.name == product.name) {
          detailController.isFavorite.value = true;
        }
      }
    }
  }
}
