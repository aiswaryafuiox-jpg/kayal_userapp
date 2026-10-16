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
  final RxString errorMessage = ''.obs;
  String? _loadedProductId;

  Future<void> refreshDetails() async {
    final dynamic id =
        product.value?.id ?? productDetail.value?.id ?? _loadedProductId;
    if (id != null && id.toString().trim().isNotEmpty) {
      await fetchProductDetails(id.toString().trim(), forceRefresh: true);
    }
  }

  @override
  void onInit() {
    super.onInit();
    resetAndFetch(Get.arguments);
  }

  @override
  void onClose() {
    _loadedProductId = null;
    productDetail.value = null;
    product.value = null;
    errorMessage.value = '';
    description.value = '';
    offerPercentage.value = '';
    super.onClose();
  }

  void resetAndFetch([dynamic args]) {
    final currentArgs = args ?? Get.arguments;
    _parseArguments(currentArgs, forceRefresh: true);
  }

  void updateArguments([dynamic args]) {
    final currentArgs = args ?? Get.arguments;
    _parseArguments(currentArgs, forceRefresh: false);
  }

  void _parseArguments(dynamic currentArgs, {bool forceRefresh = false}) {
    dynamic targetId;

    if (currentArgs != null) {
      if (currentArgs is Map) {
        if (currentArgs['isClosed'] != null) {
          isRestaurantClosed.value = currentArgs['isClosed'] == true;
        }
        if (currentArgs['notes'] != null) {
          closedNotes.value = currentArgs['notes'].toString();
        }
        if (currentArgs['product'] != null &&
            currentArgs['product'] is ProductModel) {
          final p = currentArgs['product'] as ProductModel;
          product.value = p;
          targetId = p.id;

          if (Get.isRegistered<WishlistController>()) {
            final wishlistController = Get.find<WishlistController>();
            isFavorite.value = wishlistController.isFavorite(p.name);
          } else {
            isFavorite.value = p.isFavorite.value;
          }
        } else if (currentArgs['productId'] != null ||
            currentArgs['id'] != null ||
            currentArgs['product_id'] != null ||
            currentArgs['dish_id'] != null ||
            currentArgs['dishId'] != null) {
          targetId =
              currentArgs['productId'] ??
              currentArgs['id'] ??
              currentArgs['product_id'] ??
              currentArgs['dish_id'] ??
              currentArgs['dishId'];
        }
      } else if (currentArgs is RestaurantItem) {
        isRestaurantClosed.value = !currentArgs.isOpen;
      } else if (currentArgs is ProductModel) {
        product.value = currentArgs;
        targetId = currentArgs.id;
        if (Get.isRegistered<WishlistController>()) {
          final wishlistController = Get.find<WishlistController>();
          isFavorite.value = wishlistController.isFavorite(currentArgs.name);
        } else {
          isFavorite.value = currentArgs.isFavorite.value;
        }
      } else if (currentArgs is String || currentArgs is int) {
        targetId = currentArgs;
      }
    }

    if (targetId != null && targetId.toString().trim().isNotEmpty) {
      final idStr = targetId.toString().trim();
      if (forceRefresh || _loadedProductId != idStr) {
        productDetail.value = null;
        description.value = '';
        offerPercentage.value = '';
        errorMessage.value = '';
      }
      fetchProductDetails(idStr, forceRefresh: forceRefresh);
    } else if (product.value != null && product.value!.id.isNotEmpty) {
      fetchProductDetails(product.value!.id, forceRefresh: forceRefresh);
    }
  }

  Future<void> fetchProductDetails(
    dynamic productId, {
    bool forceRefresh = false,
  }) async {
    if (productId == null || productId.toString().trim().isEmpty) {
      if (productDetail.value == null && product.value == null) {
        errorMessage.value = 'Product ID not specified';
      }
      return;
    }

    final idStr = productId.toString().trim();
    if (!forceRefresh &&
        _loadedProductId == idStr &&
        productDetail.value != null) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await _getProductDetailsUseCase(productId: idStr);

      if (response.success && response.data != null) {
        _loadedProductId = idStr;
        final data = response.data!;
        productDetail.value = data;

        description.value =
            (data.description != null && data.description!.trim().isNotEmpty)
            ? data.description!.trim().capitalizeFirstLetter()
            : '';

        offerPercentage.value =
            (data.offerPercentage != null &&
                data.offerPercentage!.trim().isNotEmpty)
            ? data.offerPercentage!.trim()
            : '';

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
          id: data.id?.toString() ?? idStr,
          name: (data.name.isNotEmpty ? data.name : (product.value?.name ?? ''))
              .capitalizeWords(),
          type: data.type.capitalizeWords(),
          isVeg: data.isVeg,
          oldPrice: effOldPrice,
          newPrice: effPrice,
          image: (data.image != null && data.image!.isNotEmpty)
              ? data.image!
              : (product.value?.image ?? ''),
          isFavorite: currentFav,
        );

        product.value = updatedProduct;
        isFavorite.value = currentFav;

        if (data.cartQuantity > 0) {
          quantity.value = data.cartQuantity;
        }
      } else {
        errorMessage.value = response.formattedErrorMessage.isNotEmpty
            ? response.formattedErrorMessage
            : 'Unable to load product details';
      }
    } catch (e) {
      debugPrint('fetchProductDetails error: $e');
      errorMessage.value =
          'Failed to load product details. Please check your connection.';
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
          return cartItem.qty;
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
