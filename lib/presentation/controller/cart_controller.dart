import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/core/utils/helper/app_toast.dart';
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

  bool _isFetchingCart = false;

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

    if (_isFetchingCart) return;
    _isFetchingCart = true;

    if (showLoading) {
      isLoadingCart.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await _getCartUseCase();
      if (response.success ?? false) {
        if (response.data != null &&
            (response.data!.items?.isNotEmpty ?? false)) {
          cartData.value = response.data;
          cartItems.assignAll(response.data!.items!);
        } else {
          cartItems.clear();
          cartData.value = null;
        }
      } else {
        errorMessage.value = response.message ?? "";
      }
    } catch (e) {
      debugPrint('Error fetching cart: $e');
      errorMessage.value = e.toString();
    } finally {
      _isFetchingCart = false;
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
      (item) =>
          item.name == name ||
          item.cartItemId == id ||
          item.productId.toString() == id ||
          item.id == id,
    );
    if (index != -1) {
      cartItems[index].quantity = (cartItems[index].quantity ?? 0) + quantity;
      cartItems.refresh();
    } else {
      cartItems.add(
        CartItem(
          cartItemId: id,
          productId: int.tryParse(id),
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
      await fetchCart(showLoading: false);
      return response;
    } catch (e) {
      debugPrint('Add to cart API call error: $e');
      await fetchCart(showLoading: false);
      return null;
    } finally {
      isApiLoading.value = false;
    }
  }

  void addLocalItem({
    required String id,
    required String name,
    required double oldPrice,
    required double newPrice,
    required String image,
    bool isVeg = true,
    int quantity = 1,
  }) {
    final parsedId = int.tryParse(id);
    final index = cartItems.indexWhere(
      (item) =>
          (parsedId != null && item.productId == parsedId) ||
          item.id == id ||
          item.cartItemId == id ||
          (item.name != null &&
              name.isNotEmpty &&
              item.name!.toLowerCase().trim() == name.toLowerCase().trim()),
    );
    if (index != -1) {
      cartItems[index].quantity = (cartItems[index].quantity ?? 0) + quantity;
      cartItems.refresh();
    } else {
      cartItems.add(
        CartItem(
          cartItemId: id,
          productId: parsedId,
          name: name.capitalizeWords(),
          sellPrice: newPrice,
          mrp: oldPrice.toInt(),
          imageUrl: image,
          isVeg: isVeg,
          quantity: quantity,
        ),
      );
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
      await fetchCart(showLoading: false);
      return response;
    } catch (e) {
      debugPrint('apiAddToCart error: $e');
      await fetchCart(showLoading: false);
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
      await fetchCart(showLoading: false);
      return response;
    } catch (e) {
      debugPrint('updateCartQuantity error: $e');
      await fetchCart(showLoading: false);
      return null;
    } finally {
      isApiLoading.value = false;
    }
  }

  Future<void> incrementQuantity(int index) async {
    if (index >= 0 && index < cartItems.length) {
      final currentQty = cartItems[index].quantity ?? 0;
      cartItems[index].quantity = currentQty + 1;
      cartItems.refresh();
      final item = cartItems[index];
      final idToUse = (item.productId?.toString() ?? item.id);
      await updateCartQuantity(cartId: idToUse, quantity: item.qty);
    }
  }

  Future<void> decrementQuantity(int index) async {
    if (index >= 0 && index < cartItems.length) {
      final currentQty = cartItems[index].quantity ?? 1;
      if (currentQty > 1) {
        cartItems[index].quantity = currentQty - 1;
        cartItems.refresh();
        final item = cartItems[index];
        final idToUse = (item.productId?.toString() ?? item.id);
        await updateCartQuantity(cartId: idToUse, quantity: item.qty);
      } else {
        await removeItem(index);
      }
    }
  }

  Future<RemoveCartItemResponseModel?> removeCartItem({
    dynamic productId,
    dynamic cartId,
  }) async {
    try {
      isApiLoading.value = true;
      final idToUse = productId ?? cartId;
      final response = await _removeCartItemUseCase(
        productId: idToUse,
        cartId: cartId,
      );
      await fetchCart(showLoading: false);
      return response;
    } catch (e) {
      debugPrint('removeCartItem error: $e');
      await fetchCart(showLoading: false);
      return null;
    } finally {
      isApiLoading.value = false;
    }
  }

  Future<void> removeItem(int index) async {
    if (index >= 0 && index < cartItems.length) {
      final item = cartItems[index];
      cartItems.removeAt(index);
      // Pass product id not cart id when removing an item
      final productIdToUse = (item.productId != null && item.productId! > 0)
          ? item.productId.toString()
          : (item.cartItemId != null && item.cartItemId!.isNotEmpty)
          ? item.cartItemId!
          : item.id;
      await removeCartItem(productId: productIdToUse);
    }
  }

  Future<void> removeItemById(dynamic id) async {
    final idStr = id?.toString();
    final index = cartItems.indexWhere(
      (item) =>
          item.productId?.toString() == idStr ||
          item.cartItemId?.toString() == idStr ||
          item.id.toString() == idStr,
    );
    if (index != -1) {
      final item = cartItems[index];
      cartItems.removeAt(index);
      final productIdToUse = (item.productId != null && item.productId! > 0)
          ? item.productId.toString()
          : (item.cartItemId != null && item.cartItemId!.isNotEmpty)
          ? item.cartItemId!
          : item.id;
      await removeCartItem(productId: productIdToUse);
    } else {
      await removeCartItem(productId: id);
    }
  }

  Future<ClearCartResponseModel?> clearCart() async {
    try {
      isApiLoading.value = true;
      cartItems.clear();
      cartData.value = null;
      final response = await _clearCartUseCase();
      await fetchCart(showLoading: false);
      return response;
    } catch (e) {
      debugPrint('clearCart error: $e');
      await fetchCart(showLoading: false);
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
      AppToast.warning(
        'Please add items to cart before proceeding.',
        title: 'Cart Empty',
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
