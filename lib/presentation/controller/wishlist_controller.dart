import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';

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
    wishlistItems[index].isFavorite = !wishlistItems[index].isFavorite;
    wishlistItems.refresh();
  }
}
