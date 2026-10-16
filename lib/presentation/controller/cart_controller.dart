import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/add_to_cart_response_model.dart';
import 'package:kayal_userapp/data/model/clear_cart_response_model.dart';
import 'package:kayal_userapp/data/model/get_cart_response_model.dart';
import 'package:kayal_userapp/data/model/remove_cart_item_response_model.dart';
import 'package:kayal_userapp/data/model/update_quantity_response_model.dart';
import 'package:kayal_userapp/data/repository/add_to_cart_repository_impl.dart';
import 'package:kayal_userapp/data/repository/clear_cart_repository_impl.dart';
import 'package:kayal_userapp/data/repository/get_cart_repository_impl.dart';
import 'package:kayal_userapp/data/repository/remove_cart_item_repository_impl.dart';
import 'package:kayal_userapp/data/repository/update_quantity_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/add_to_cart_usecase.dart';
import 'package:kayal_userapp/domain/usecase/clear_cart_usecase.dart';
import 'package:kayal_userapp/domain/usecase/get_cart_usecase.dart';
import 'package:kayal_userapp/domain/usecase/remove_cart_item_usecase.dart';
import 'package:kayal_userapp/domain/usecase/update_quantity_usecase.dart';
// To parse this JSON data, do
//
//     final cartItemModel = cartItemModelFromJson(jsonString);

class CartController extends GetxController {
  final AddToCartUseCase _addToCartUseCase;
  final GetCartUseCase _getCartUseCase;
  final UpdateQuantityUseCase _updateQuantityUseCase;
  final RemoveCartItemUseCase _removeCartItemUseCase;
  final ClearCartUseCase _clearCartUseCase;

  CartController({
    AddToCartUseCase? addToCartUseCase,
    GetCartUseCase? getCartUseCase,
    UpdateQuantityUseCase? updateQuantityUseCase,
    RemoveCartItemUseCase? removeCartItemUseCase,
    ClearCartUseCase? clearCartUseCase,
  }) : _addToCartUseCase =
           addToCartUseCase ??
           (sl.isRegistered<AddToCartUseCase>()
               ? sl<AddToCartUseCase>()
               : AddToCartUseCase(AddToCartRepositoryImpl(ApiService()))),
       _getCartUseCase =
           getCartUseCase ??
           (sl.isRegistered<GetCartUseCase>()
               ? sl<GetCartUseCase>()
               : GetCartUseCase(GetCartRepositoryImpl(ApiService()))),
       _updateQuantityUseCase =
           updateQuantityUseCase ??
           (sl.isRegistered<UpdateQuantityUseCase>()
               ? sl<UpdateQuantityUseCase>()
               : UpdateQuantityUseCase(
                   UpdateQuantityRepositoryImpl(ApiService()),
                 )),
       _removeCartItemUseCase =
           removeCartItemUseCase ??
           (sl.isRegistered<RemoveCartItemUseCase>()
               ? sl<RemoveCartItemUseCase>()
               : RemoveCartItemUseCase(
                   RemoveCartItemRepositoryImpl(ApiService()),
                 )),
       _clearCartUseCase =
           clearCartUseCase ??
           (sl.isRegistered<ClearCartUseCase>()
               ? sl<ClearCartUseCase>()
               : ClearCartUseCase(ClearCartRepositoryImpl(ApiService())));

  final cartItems = <CartItem>[].obs;
  final Rxn<GetCartData> cartData = Rxn<GetCartData>();
  final RxBool isApiLoading = false.obs;
  final RxBool isLoadingCart = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  Future<void> fetchCart({bool showLoading = true}) async {
    final token = LocalStorageService().getString("auth_token");
    if (token == null ||
        token.trim().isEmpty ||
        token.startsWith("pms_token_")) {
      cartItems.clear();
      cartData.value = null;
      isLoadingCart.value = false;
      return;
    }

    if (showLoading) {
      isLoadingCart.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await _getCartUseCase();
      if ((response.success ?? false) &&
          (response.data?.items?.isNotEmpty ?? false)) {
        cartData.value = response.data;
        cartItems.assignAll(response.data!.items!);
      } else if ((response.data?.items?.isEmpty ?? false)) {
        cartItems.clear();
        cartData.value = null;
      } else {
        errorMessage.value = response.message ?? "";
      }
    } catch (e) {
      debugPrint('Error fetching cart: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoadingCart.value = false;
    }
  }

  Future<AddToCartResponseModel?> addItem({
    required String id,
    required String name,
    required String type,
    required bool isVeg,
    required double oldPrice,
    required double newPrice,
    required String image,
    int quantity = 1,
  }) async {
    final index = cartItems.indexWhere(
      (item) => item.name == name || item.cartItemId == id,
    );
    if (index != -1) {
      cartItems[index].quantity = (cartItems[index].quantity ?? 0) + quantity;
    } else {
      cartItems.add(
        CartItem(
          cartItemId: id,
          name: name.capitalizeWords(),
          sellPrice: newPrice,
          mrp: oldPrice.toInt(),
          imageUrl: image,
          quantity: quantity,
        ),
      );
    }

    try {
      isApiLoading.value = true;
      final response = await _addToCartUseCase(
        productId: id,
        quantity: quantity,
      );
      if (response.success) {
        debugPrint('Item added to cart on server: ${response.message}');
      }
      return response;
    } catch (e) {
      debugPrint('Add to cart API call error: $e');
      return null;
    } finally {
      isApiLoading.value = false;
    }
  }

  Future<AddToCartResponseModel?> apiAddToCart({
    required dynamic productId,
    required dynamic quantity,
  }) async {
    try {
      isApiLoading.value = true;
      final response = await _addToCartUseCase(
        productId: productId,
        quantity: quantity,
      );
      return response;
    } catch (e) {
      debugPrint('apiAddToCart error: $e');
      return null;
    } finally {
      isApiLoading.value = false;
    }
  }

  Future<UpdateQuantityResponseModel?> updateCartQuantity({
    required dynamic cartId,
    required dynamic quantity,
  }) async {
    try {
      isApiLoading.value = true;
      final response = await _updateQuantityUseCase(
        cartId: cartId,
        quantity: quantity,
      );
      if (response.success) {
        fetchCart(showLoading: false);
      }
      return response;
    } catch (e) {
      debugPrint('updateCartQuantity error: $e');
      return null;
    } finally {
      isApiLoading.value = false;
    }
  }

  void incrementQuantity(int index) {
    if (index >= 0 && index < cartItems.length) {
      final currentQty = cartItems[index].quantity ?? 0;
      cartItems[index].quantity = currentQty + 1;
      cartItems.refresh();
      final item = cartItems[index];
      updateCartQuantity(cartId: item.productId, quantity: item.qty);
    }
  }

  void decrementQuantity(int index) {
    if (index >= 0 && index < cartItems.length) {
      final currentQty = cartItems[index].quantity ?? 1;
      if (currentQty > 1) {
        cartItems[index].quantity = currentQty - 1;
        cartItems.refresh();
        final item = cartItems[index];
        updateCartQuantity(cartId: item.productId, quantity: item.qty);
      } else {
        removeItem(index);
      }
    }
  }

  Future<RemoveCartItemResponseModel?> removeCartItem({
    required dynamic cartId,
  }) async {
    try {
      isApiLoading.value = true;
      final response = await _removeCartItemUseCase(cartId: cartId);
      if (response.success) {
        fetchCart(showLoading: false);
      }
      return response;
    } catch (e) {
      debugPrint('removeCartItem error: $e');
      return null;
    } finally {
      isApiLoading.value = false;
    }
  }

  Future<void> removeItem(int index) async {
    if (index >= 0 && index < cartItems.length) {
      final item = cartItems[index];
      cartItems.removeAt(index);
      await removeCartItem(cartId: item.productId);
    }
  }

  Future<void> removeItemById(dynamic id) async {
    final index = cartItems.indexWhere(
      (item) => item.productId.toString() == id.toString(),
    );
    if (index != -1) {
      final item = cartItems[index];
      cartItems.removeAt(index);
      await removeCartItem(cartId: item.productId);
    }
  }

  Future<ClearCartResponseModel?> clearCart() async {
    try {
      isApiLoading.value = true;
      cartItems.clear();
      cartData.value = null;
      final response = await _clearCartUseCase();
      if (response.success) {
        fetchCart(showLoading: false);
      }
      return response;
    } catch (e) {
      debugPrint('clearCart error: $e');
      return null;
    } finally {
      isApiLoading.value = false;
    }
  }

  int get cartCount => cartItems.length;

  int get totalQuantity => cartItems.fold(0, (sum, item) => sum + item.qty);

  double get totalAmount {
    if (cartData.value?.totalAmount != null &&
        cartData.value!.totalAmount! > 0) {
      return cartData.value!.totalAmount!;
    }
    return cartItems.fold(0.0, (sum, item) => sum + (item.newPrice * item.qty));
  }

  Future<void> proceedToCheckout() async {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Cart Empty',
        'Please add items to cart before proceeding.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final isLoggedIn = LocalStorageService().isLoggedIn();

    if (isLoggedIn) {
      Get.toNamed(AppRoutes.orderSummary);
    } else {
      Get.toNamed(
        AppRoutes.login,
        arguments: {'redirect': AppRoutes.orderSummary},
      );
    }
  }
}
