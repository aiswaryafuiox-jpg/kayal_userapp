import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/product_details_response_model.dart';
import 'package:kayal_userapp/data/repository/product_details_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/get_product_details_usecase.dart';
import 'package:kayal_userapp/presentation/controller/cart_controller.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';
import 'package:kayal_userapp/presentation/controller/product_controller.dart';
import 'package:kayal_userapp/presentation/controller/wishlist_controller.dart';

class ProductDetailController extends GetxController {
  final GetProductDetailsUseCase _getProductDetailsUseCase;

  ProductDetailController({GetProductDetailsUseCase? getProductDetailsUseCase})
    : _getProductDetailsUseCase =
          getProductDetailsUseCase ??
          (sl.isRegistered<GetProductDetailsUseCase>()
              ? sl<GetProductDetailsUseCase>()
              : GetProductDetailsUseCase(
                  ProductDetailsRepositoryImpl(ApiService()),
                ));

  final quantity = 1.obs;
  final isFavorite = false.obs;
  final isRestaurantClosed = false.obs;
  final closedNotes =
      'This restaurant is currently unavailable.\nOpens today at 10:00 AM'.obs;
  final Rxn<ProductModel> product = Rxn<ProductModel>();
  final Rxn<ProductDetailDataModel> productDetail =
      Rxn<ProductDetailDataModel>();
  final RxBool isLoading = false.obs;
  final RxString description = ''.obs;
  final RxString offerPercentage = ''.obs;

  Future<void> refreshDetails() async {
    final dynamic id = product.value?.id ?? productDetail.value?.id;
    if (id != null && id.toString().isNotEmpty) {
      await fetchProductDetails(id);
    }
  }

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

          if (Get.isRegistered<WishlistController>()) {
            final wishlistController = Get.find<WishlistController>();
            isFavorite.value = wishlistController.isFavorite(
              product.value!.name,
            );
          }

          if (product.value!.id.isNotEmpty) {
            fetchProductDetails(product.value!.id);
          }
        } else if (currentArgs['productId'] != null ||
            currentArgs['id'] != null) {
          final id = currentArgs['productId'] ?? currentArgs['id'];
          fetchProductDetails(id);
        }
      } else if (currentArgs is RestaurantItem) {
        isRestaurantClosed.value = !currentArgs.isOpen;
      } else if (currentArgs is ProductModel) {
        product.value = currentArgs;
        if (Get.isRegistered<WishlistController>()) {
          final wishlistController = Get.find<WishlistController>();
          isFavorite.value = wishlistController.isFavorite(product.value!.name);
        }
        if (currentArgs.id.isNotEmpty) {
          fetchProductDetails(currentArgs.id);
        }
      } else if (currentArgs is String || currentArgs is int) {
        fetchProductDetails(currentArgs);
      }
    }
  }

  Future<void> fetchProductDetails(dynamic productId) async {
    try {
      isLoading.value = true;
      final response = await _getProductDetailsUseCase(productId: productId);
      if (response.success && response.data != null) {
        final data = response.data!;
        productDetail.value = data;

        if (data.description != null && data.description!.isNotEmpty) {
          description.value = data.description!.capitalizeFirstLetter();
        }

        if (data.offerPercentage != null && data.offerPercentage!.isNotEmpty) {
          offerPercentage.value = data.offerPercentage!;
        }

        final wishlistController = Get.isRegistered<WishlistController>()
            ? Get.find<WishlistController>()
            : null;

        final currentFav = wishlistController != null
            ? wishlistController.isFavorite(data.name)
            : (product.value?.isFavorite.value ?? false);

        final double effPrice = data.price > 0
            ? data.price
            : ((product.value != null && product.value!.newPrice > 0)
                ? product.value!.newPrice
                : data.oldPrice);
        final double effOldPrice = data.oldPrice > 0
            ? data.oldPrice
            : ((product.value != null && product.value!.oldPrice > 0)
                ? product.value!.oldPrice
                : effPrice);

        final updatedProduct = ProductModel(
          id: data.id?.toString() ?? productId.toString(),
          name: (data.name.isNotEmpty
                  ? data.name
                  : (product.value?.name ?? 'Product Details'))
              .capitalizeWords(),
          type: data.type.capitalizeWords(),
          isVeg: data.isVeg,
          oldPrice: effOldPrice,
          newPrice: effPrice,
          image: (data.image != null && data.image!.isNotEmpty)
              ? data.image!
              : (product.value?.image ?? 'assets/images/product1.png'),
          isFavorite: currentFav,
        );

        product.value = updatedProduct;
        isFavorite.value = currentFav;
      }
    } catch (e) {
      debugPrint('fetchProductDetails error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  int get currentQuantity {
    if (Get.isRegistered<CartController>()) {
      final cartController = Get.find<CartController>();
      final prod = product.value;
      if (prod != null) {
        final cartItem = cartController.cartItems.firstWhereOrNull(
          (item) => item.id == prod.id || item.name == prod.name,
        );
        if (cartItem != null) {
          return cartItem.quantity.value;
        }
      }
    }
    return 0;
  }

  void incrementQuantity() {
    if (isRestaurantClosed.value) {
      Get.snackbar(
        'Restaurant Unavailable',
        'Cannot add items to cart while restaurant is closed.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (product.value != null && Get.isRegistered<CartController>()) {
      final cartController = Get.find<CartController>();
      final prod = product.value!;
      final cartIndex = cartController.cartItems.indexWhere(
        (item) => item.name == prod.name || item.id == prod.id,
      );
      if (cartIndex != -1) {
        cartController.incrementQuantity(cartIndex);
      } else {
        cartController.addItem(
          id: prod.id,
          name: prod.name,
          type: prod.type,
          isVeg: prod.isVeg,
          oldPrice: prod.oldPrice,
          newPrice: prod.newPrice,
          image: prod.image,
          quantity: 1,
        );
      }
    }
  }

  void decrementQuantity() {
    if (isRestaurantClosed.value) {
      return;
    }

    if (product.value != null && Get.isRegistered<CartController>()) {
      final cartController = Get.find<CartController>();
      final prod = product.value!;
      final cartIndex = cartController.cartItems.indexWhere(
        (item) => item.name == prod.name || item.id == prod.id,
      );
      if (cartIndex != -1) {
        cartController.decrementQuantity(cartIndex);
      }
    }
  }

  void toggleFavorite() {
    if (product.value != null) {
      if (Get.isRegistered<WishlistController>()) {
        final wishlistController = Get.find<WishlistController>();
        wishlistController.toggleProductFavorite(product.value!);
        isFavorite.value = product.value!.isFavorite.value;
      } else {
        isFavorite.value = !isFavorite.value;
        product.value!.isFavorite.value = isFavorite.value;
      }
    }
  }

  void addToCart() {
    incrementQuantity();
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

    if (product.value != null && Get.isRegistered<CartController>()) {
      final cartController = Get.find<CartController>();
      final prod = product.value!;
      final cartIndex = cartController.cartItems.indexWhere(
        (item) => item.name == prod.name || item.id == prod.id,
      );
      if (cartIndex == -1) {
        await cartController.addItem(
          id: prod.id,
          name: prod.name,
          type: prod.type,
          isVeg: prod.isVeg,
          oldPrice: prod.oldPrice,
          newPrice: prod.newPrice,
          image: prod.image,
          quantity: 1,
        );
      }
    }

    final int qty = currentQuantity > 0 ? currentQuantity : 1;
    final args = product.value != null
        ? {'product': product.value, 'quantity': qty}
        : null;

    Get.toNamed(AppRoutes.orderSummary, arguments: args);
  }

  void goBack() {
    Get.back();
  }
}
