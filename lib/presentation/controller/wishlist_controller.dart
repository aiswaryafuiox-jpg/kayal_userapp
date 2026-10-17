import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/data/model/add_to_cart_from_wishlist_response_model.dart';
import 'package:kayal_userapp/data/model/get_wishlist_response_model.dart';
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

class WishlistController extends GetxController {
  final GetWishlistUseCase _getWishlistUseCase;
  final ToggleWishlistUseCase _toggleWishlistUseCase;
  final AddToCartFromWishlistUseCase _addToCartFromWishlistUseCase;

  WishlistController({
    GetWishlistUseCase? getWishlistUseCase,
    ToggleWishlistUseCase? toggleWishlistUseCase,
    AddToCartFromWishlistUseCase? addToCartFromWishlistUseCase,
  }) : _getWishlistUseCase =
           getWishlistUseCase ??
           (sl.isRegistered<GetWishlistUseCase>()
               ? sl<GetWishlistUseCase>()
               : GetWishlistUseCase(GetWishlistRepositoryImpl(ApiService()))),
       _toggleWishlistUseCase =
           toggleWishlistUseCase ??
           (sl.isRegistered<ToggleWishlistUseCase>()
               ? sl<ToggleWishlistUseCase>()
               : ToggleWishlistUseCase(
                   ToggleWishlistRepositoryImpl(ApiService()),
                 )),
       _addToCartFromWishlistUseCase =
           addToCartFromWishlistUseCase ??
           (sl.isRegistered<AddToCartFromWishlistUseCase>()
               ? sl<AddToCartFromWishlistUseCase>()
               : AddToCartFromWishlistUseCase(
                   AddToCartFromWishlistRepositoryImpl(ApiService()),
                 ));

  final wishlistItems = <WishlistItemModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  Future<void> fetchWishlist({bool showLoading = true}) async {
    final token = LocalStorageService().getString("auth_token");
    if (token == null ||
        token.trim().isEmpty ||
        token.startsWith("pms_token_")) {
      isLoading.value = false;
      return;
    }

    if (showLoading) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await _getWishlistUseCase();
      if ((response.success ?? false) && (response.data != null)) {
        final items = response.data?.items ?? [];
        wishlistItems.assignAll(items);
      } else if ((response.data?.items?.isEmpty ?? true)) {
        errorMessage.value = "Wishlist is Empty";
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

  final Set<String> _pendingAddProductIds = <String>{};

  Future<AddToCartFromWishlistResponseModel?> addToCartFromWishlist({
    required WishlistItemModel item,
    int quantity = 1,
  }) async {
    final prodId = item.productId?.toString() ?? '';
    if (prodId.isEmpty || _pendingAddProductIds.contains(prodId)) {
      return null;
    }
    _pendingAddProductIds.add(prodId);

    // Optimistically update local cart WITHOUT triggering a second API call
    final cart = _cartController;
    cart.addLocalItem(
      id: prodId,
      name: item.name ?? '',
      isVeg: item.isVeg ?? false,
      oldPrice: item.mrp?.toDouble() ?? 0.0,
      newPrice: item.sellPrice?.toDouble() ?? 0.0,
      image: item.imageUrl ?? '',
      quantity: quantity,
    );

    try {
      final response = await _addToCartFromWishlistUseCase(
        productId: item.productId,
        quantity: quantity,
      );
      if (response.success) {
        await cart.fetchCart(showLoading: false);
      } else {
        await cart.fetchCart(showLoading: false);
      }
      return response;
    } catch (e) {
      debugPrint('addToCartFromWishlist error: $e');
      await cart.fetchCart(showLoading: false);
      return null;
    } finally {
      _pendingAddProductIds.remove(prodId);
    }
  }

  void toggleFavorite(int index) {
    if (index < 0 || index >= wishlistItems.length) return;
    final item = wishlistItems[index];
    final productId = item.productId;
    wishlistItems.removeAt(index);

    // Call toggle wishlist API
    toggleWishlistApi(productId: productId);

    // Sync with ProductController if registered
    if (Get.isRegistered<ProductController>()) {
      final productController = Get.find<ProductController>();
      final prodIndex = productController.products.indexWhere(
        (p) => p.name == item.name || p.id == item.productId.toString(),
      );
      if (prodIndex != -1) {
        productController.products[prodIndex].isFavorite.value = false;
      }
    }

    // Sync with ProductDetailController if registered
    if (Get.isRegistered<ProductDetailController>()) {
      final detailController = Get.find<ProductDetailController>();
      if (detailController.product.value?.name == item.name ||
          detailController.product.value?.id == item.productId.toString()) {
        detailController.isFavorite.value = false;
      }
    }
  }

  bool isFavorite(String title) {
    return wishlistItems.any((item) => item.name == title);
  }

  void toggleProductFavorite(ProductModel product) {
    final index = wishlistItems.indexWhere(
      (item) =>
          item.name == product.name || item.productId.toString() == product.id,
    );
    final productId = product.id.isNotEmpty ? product.id : '1';

    // Call toggle wishlist API
    toggleWishlistApi(productId: productId);

    if (index != -1) {
      wishlistItems.removeAt(index);
      product.isFavorite.value = false;

      // Also update ProductDetailController if the active product is this one
      if (Get.isRegistered<ProductDetailController>()) {
        final detailController = Get.find<ProductDetailController>();
        if (detailController.product.value?.name == product.name ||
            detailController.product.value?.id == product.id) {
          detailController.isFavorite.value = false;
        }
      }
    } else {
      wishlistItems.add(
        WishlistItemModel(
          productId: int.parse(productId),
          name: product.name,
          isVeg: product.isVeg,
          mrp: product.oldPrice,
          sellPrice: product.newPrice,
          imageUrl: product.image,
        ),
      );
      product.isFavorite.value = true;

      // Also update ProductDetailController if the active product is this one
      if (Get.isRegistered<ProductDetailController>()) {
        final detailController = Get.find<ProductDetailController>();
        if (detailController.product.value?.name == product.name ||
            detailController.product.value?.id == product.id) {
          detailController.isFavorite.value = true;
        }
      }
    }
  }

  CartController get _cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController());
  }

  int getQuantity(WishlistItemModel product) {
    final cart = _cartController;
    final cartItem = cart.cartItems.firstWhereOrNull(
      (c) =>
          (product.productId != null && c.productId == product.productId) ||
          c.id == product.productId?.toString() ||
          c.cartItemId == product.productId?.toString() ||
          (product.name != null &&
              c.name?.toLowerCase().trim() ==
                  product.name?.toLowerCase().trim()),
    );
    if (cartItem != null) {
      return cartItem.qty;
    }
    return 0;
  }

  void incrementQuantity(WishlistItemModel product) {
    if (Get.isRegistered<CartController>()) {
      final cartController = Get.find<CartController>();
      final cartIndex = cartController.cartItems.indexWhere(
        (item) =>
            item.productId == product.productId ||
            item.name?.toLowerCase() == product.name?.toLowerCase(),
      );
      if (cartIndex != -1) {
        cartController.incrementQuantity(cartIndex);
      } else {
        cartController.addItem(
          id: product.productId.toString(),
          name: product.name ?? '',
          type: product.isVeg == true ? 'veg' : 'non-veg',
          isVeg: product.isVeg ?? false,
          oldPrice: product.mrp?.toDouble() ?? 0,
          newPrice: product.sellPrice?.toDouble() ?? 0,
          image: product.imageUrl ?? '',
          quantity: 1,
        );
      }
    }
  }

  void decrementQuantity(WishlistItemModel product) {
    if (Get.isRegistered<CartController>()) {
      final cartController = Get.find<CartController>();
      final cartIndex = cartController.cartItems.indexWhere(
        (item) =>
            item.productId == product.productId ||
            item.name?.toLowerCase() == product.name?.toLowerCase(),
      );
      if (cartIndex != -1) {
        cartController.decrementQuantity(cartIndex);
      }
    }
  }

  void toggleFavoriteItem(WishlistItemModel product) {
    final index = wishlistItems.indexWhere(
      (w) => w.productId == product.productId,
    );
    if (index != -1) {
      toggleFavorite(index);
    } else {
      toggleWishlistApi(productId: product.productId);
    }
  }

  void toggleFavoriteById(int id) {
    final index = wishlistItems.indexWhere((w) => w.productId == id);
    if (index != -1) {
      toggleFavorite(index);
    } else {
      toggleWishlistApi(productId: id);
    }
  }
}
