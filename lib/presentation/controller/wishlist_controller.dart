import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/data/model/add_to_cart_from_wishlist_response_model.dart';
import 'package:kayal_userapp/data/model/toggle_wishlist_response_model.dart';
import 'package:kayal_userapp/data/repository/add_to_cart_from_wishlist_repository_impl.dart';
import 'package:kayal_userapp/data/repository/get_wishlist_repository_impl.dart';
import 'package:kayal_userapp/data/repository/toggle_wishlist_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/add_to_cart_from_wishlist_usecase.dart';
import 'package:kayal_userapp/domain/usecase/get_wishlist_usecase.dart';
import 'package:kayal_userapp/domain/usecase/toggle_wishlist_usecase.dart';
import 'package:kayal_userapp/presentation/controller/cart_controller.dart';
import 'package:kayal_userapp/presentation/controller/product_controller.dart';
import 'package:kayal_userapp/presentation/controller/product_detail_controller.dart';

class WishlistItem {
  final String id;
  final String title;
  final String type;
  final bool isVeg;
  final double originalPrice;
  final double price;
  final String image;
  final String discount;
  bool isFavorite;

  WishlistItem({
    this.id = '1',
    required this.title,
    required this.type,
    required this.isVeg,
    required this.originalPrice,
    required this.price,
    required this.image,
    this.discount = '20 %',
    this.isFavorite = true,
  });
}

class WishlistController extends GetxController {
  final GetWishlistUseCase _getWishlistUseCase;
  final ToggleWishlistUseCase _toggleWishlistUseCase;
  final AddToCartFromWishlistUseCase _addToCartFromWishlistUseCase;

  WishlistController({
    GetWishlistUseCase? getWishlistUseCase,
    ToggleWishlistUseCase? toggleWishlistUseCase,
    AddToCartFromWishlistUseCase? addToCartFromWishlistUseCase,
  })  : _getWishlistUseCase = getWishlistUseCase ??
            (sl.isRegistered<GetWishlistUseCase>()
                ? sl<GetWishlistUseCase>()
                : GetWishlistUseCase(GetWishlistRepositoryImpl(ApiService()))),
        _toggleWishlistUseCase = toggleWishlistUseCase ??
            (sl.isRegistered<ToggleWishlistUseCase>()
                ? sl<ToggleWishlistUseCase>()
                : ToggleWishlistUseCase(ToggleWishlistRepositoryImpl(ApiService()))),
        _addToCartFromWishlistUseCase = addToCartFromWishlistUseCase ??
            (sl.isRegistered<AddToCartFromWishlistUseCase>()
                ? sl<AddToCartFromWishlistUseCase>()
                : AddToCartFromWishlistUseCase(AddToCartFromWishlistRepositoryImpl(ApiService())));

  final wishlistItems = <WishlistItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  Future<void> fetchWishlist({bool showLoading = true}) async {
    final token = LocalStorageService().getString("auth_token");
    if (token == null || token.trim().isEmpty || token.startsWith("pms_token_")) {
      isLoading.value = false;
      return;
    }

    if (showLoading) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await _getWishlistUseCase();
      if (response.success && response.data.isNotEmpty) {
        final items = response.data.map((item) {
          return WishlistItem(
            id: (item.productId ?? item.id ?? '1').toString(),
            title: item.name,
            type: item.type,
            isVeg: item.isVeg,
            originalPrice: item.oldPrice,
            price: item.price,
            image: item.image.isNotEmpty ? item.image : productImg1,
            discount: item.discount,
            isFavorite: true,
          );
        }).toList();
        wishlistItems.assignAll(items);
      } else if (response.data.isEmpty && !response.success) {
        errorMessage.value = response.formattedErrorMessage;
      }
    } catch (e) {
      debugPrint('fetchWishlist error: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<ToggleWishlistResponseModel?> toggleWishlistApi({
    required dynamic productId,
  }) async {
    try {
      final response = await _toggleWishlistUseCase(productId: productId);
      return response;
    } catch (e) {
      debugPrint('toggleWishlistApi error: $e');
      return null;
    }
  }

  Future<AddToCartFromWishlistResponseModel?> addToCartFromWishlist({
    required WishlistItem item,
    int quantity = 1,
  }) async {
    // Optimistically update / show in cart
    if (Get.isRegistered<CartController>()) {
      final cartController = Get.find<CartController>();
      cartController.addItem(
        id: item.id.isNotEmpty ? item.id : '1',
        name: item.title,
        type: item.type,
        isVeg: item.isVeg,
        oldPrice: item.originalPrice,
        newPrice: item.price,
        image: item.image,
        quantity: quantity,
      );
    }

    try {
      final response = await _addToCartFromWishlistUseCase(
        productId: item.id,
        quantity: quantity,
      );
      if (response.success && Get.isRegistered<CartController>()) {
        Get.find<CartController>().fetchCart(showLoading: false);
      }
      return response;
    } catch (e) {
      debugPrint('addToCartFromWishlist error: $e');
      return null;
    }
  }

  void toggleFavorite(int index) {
    if (index < 0 || index >= wishlistItems.length) return;
    final item = wishlistItems[index];
    final productId = item.id;
    wishlistItems.removeAt(index);

    // Call toggle wishlist API
    toggleWishlistApi(productId: productId);

    // Sync with ProductController if registered
    if (Get.isRegistered<ProductController>()) {
      final productController = Get.find<ProductController>();
      final prodIndex = productController.products.indexWhere((p) => p.name == item.title || p.id == item.id);
      if (prodIndex != -1) {
        productController.products[prodIndex].isFavorite.value = false;
      }
    }

    // Sync with ProductDetailController if registered
    if (Get.isRegistered<ProductDetailController>()) {
      final detailController = Get.find<ProductDetailController>();
      if (detailController.product.value?.name == item.title || detailController.product.value?.id == item.id) {
        detailController.isFavorite.value = false;
      }
    }
  }

  bool isFavorite(String title) {
    return wishlistItems.any((item) => item.title == title);
  }

  void toggleProductFavorite(ProductModel product) {
    final index = wishlistItems.indexWhere((item) => item.title == product.name || item.id == product.id);
    final productId = product.id.isNotEmpty ? product.id : '1';

    // Call toggle wishlist API
    toggleWishlistApi(productId: productId);

    if (index != -1) {
      wishlistItems.removeAt(index);
      product.isFavorite.value = false;

      // Also update ProductDetailController if the active product is this one
      if (Get.isRegistered<ProductDetailController>()) {
        final detailController = Get.find<ProductDetailController>();
        if (detailController.product.value?.name == product.name || detailController.product.value?.id == product.id) {
          detailController.isFavorite.value = false;
        }
      }
    } else {
      wishlistItems.add(
        WishlistItem(
          id: productId,
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
        if (detailController.product.value?.name == product.name || detailController.product.value?.id == product.id) {
          detailController.isFavorite.value = true;
        }
      }
    }
  }
}
