import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/category_products_response_model.dart';
import 'package:kayal_userapp/data/repository/category_products_repository_impl.dart';
import 'package:kayal_userapp/data/repository/restaurant_products_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/get_category_products_usecase.dart';
import 'package:kayal_userapp/domain/usecase/restaurant_products_usecase.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';
import 'package:kayal_userapp/presentation/controller/wishlist_controller.dart';
import 'package:kayal_userapp/presentation/controller/cart_controller.dart';

class ProductController extends GetxController {
  final GetCategoryProductsUseCase _getCategoryProductsUseCase;
  final RestaurantProductsUseCase _restaurantProductsUseCase;

  ProductController({
    GetCategoryProductsUseCase? getCategoryProductsUseCase,
    RestaurantProductsUseCase? restaurantProductsUseCase,
  })  : _getCategoryProductsUseCase = getCategoryProductsUseCase ??
            (sl.isRegistered<GetCategoryProductsUseCase>()
                ? sl<GetCategoryProductsUseCase>()
                : GetCategoryProductsUseCase(
                    CategoryProductsRepositoryImpl(ApiService()))),
        _restaurantProductsUseCase = restaurantProductsUseCase ??
            (sl.isRegistered<RestaurantProductsUseCase>()
                ? sl<RestaurantProductsUseCase>()
                : RestaurantProductsUseCase(
                    RestaurantProductsRepositoryImpl(ApiService())));

  final products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final isRestaurantClosed = false.obs;
  final closedNotes =
      'This restaurant is currently unavailable.\nOpens today at 10:00 AM'.obs;
  final title = 'Product List'.obs;
  dynamic categoryId;
  dynamic restaurantId;

  @override
  void onInit() {
    super.onInit();
    updateArguments(Get.arguments);
    _loadProducts();
  }

  void updateArguments([dynamic args]) {
    final currentArgs = args ?? Get.arguments;
    if (currentArgs != null) {
      final oldCatId = categoryId;
      final oldRestId = restaurantId;

      if (currentArgs is RestaurantItem) {
        title.value = currentArgs.name.capitalizeWords();
        isRestaurantClosed.value = !currentArgs.isOpen;
        if (!currentArgs.isOpen) {
          closedNotes.value =
              'This restaurant is currently unavailable.\n${currentArgs.openingTime}';
        }
        if (currentArgs.id != null) {
          restaurantId = currentArgs.id;
          categoryId ??= 1;
        }
      } else if (currentArgs is Map) {
        if (currentArgs['restaurant'] != null &&
            currentArgs['restaurant'] is RestaurantItem) {
          final RestaurantItem r = currentArgs['restaurant'];
          title.value = r.name.capitalizeWords();
          restaurantId = r.id;
          isRestaurantClosed.value = !r.isOpen;
          if (!r.isOpen) {
            closedNotes.value =
                'This restaurant is currently unavailable.\n${r.openingTime}';
          }
        } else if (currentArgs['restaurant'] != null &&
            currentArgs['restaurant'] is Map) {
          final Map r = currentArgs['restaurant'];
          if (r['name'] != null) title.value = r['name'].toString().capitalizeWords();
          if (r['id'] != null) restaurantId = r['id'];
        } else if (currentArgs['category'] != null) {
          title.value = '${currentArgs['category'].toString().capitalizeWords()} List';
        }

        if (currentArgs['restaurantId'] != null) {
          restaurantId = currentArgs['restaurantId'];
        }
        if (currentArgs['categoryId'] != null) {
          categoryId = currentArgs['categoryId'];
        } else if (currentArgs['category_id'] != null) {
          categoryId = currentArgs['category_id'];
        }

        if (currentArgs['isClosed'] != null) {
          isRestaurantClosed.value = currentArgs['isClosed'] == true;
        }
        if (currentArgs['notes'] != null) {
          closedNotes.value = currentArgs['notes'];
        }
      }

      final shouldReload = (restaurantId != null && (restaurantId != oldRestId || categoryId != oldCatId || products.isEmpty)) ||
          (restaurantId == null && categoryId != null && (categoryId != oldCatId || products.isEmpty));

      if (shouldReload && !isLoading.value) {
        _loadProducts();
      }
    }
  }

  Future<void> refreshProducts() async {
    _loadProducts();
  }

  void _loadProducts() {
    if (restaurantId != null && categoryId != null) {
      fetchRestaurantProducts(
        restaurantId: restaurantId,
        categoryId: categoryId,
      );
    } else if (restaurantId != null) {
      fetchRestaurantProducts(
        restaurantId: restaurantId,
        categoryId: 1,
      );
    } else if (categoryId != null) {
      fetchCategoryProducts(categoryId);
    } else {
      products.clear();
    }
  }

  Future<void> fetchRestaurantProducts({
    required dynamic restaurantId,
    required dynamic categoryId,
  }) async {
    final wishlistController = Get.isRegistered<WishlistController>()
        ? Get.find<WishlistController>()
        : null;
    try {
      isLoading.value = true;
      final response = await _restaurantProductsUseCase(
        restaurantId: restaurantId,
        categoryId: categoryId,
      );

      if (response.success && response.products.isNotEmpty) {
        // If restaurant_products endpoint returns null/0 prices, enrich with category products
        final bool hasMissingPrices = response.products.any((p) => p.price <= 0);
        final Map<String, CategoryProductItemModel> catProductsMap = {};
        if (hasMissingPrices && categoryId != null) {
          try {
            final catResponse = await _getCategoryProductsUseCase(categoryId: categoryId);
            if (catResponse.success && catResponse.data.isNotEmpty) {
              for (var cp in catResponse.data) {
                catProductsMap[cp.id.toString()] = cp;
              }
            }
          } catch (_) {}
        }

        final loaded = response.products.map((item) {
          final catProduct = catProductsMap[item.id.toString()];
          final double effPrice = item.price > 0
              ? item.price
              : (catProduct != null && catProduct.price > 0 ? catProduct.price : 0.0);
          final double effOldPrice = item.oldPrice > 0
              ? item.oldPrice
              : (catProduct != null && catProduct.oldPrice > 0 ? catProduct.oldPrice : effPrice);
          final bool effIsVeg = catProduct != null ? catProduct.isVeg : item.isVeg;
          final String effType = catProduct != null ? catProduct.type : item.type;

          final model = ProductModel(
            id: item.id.toString(),
            name: item.name.capitalizeWords(),
            type: effType.capitalizeWords(),
            isVeg: effIsVeg,
            oldPrice: effOldPrice > 0 ? effOldPrice : effPrice,
            newPrice: effPrice,
            image: (item.image != null && item.image!.isNotEmpty)
                ? item.image!
                : (catProduct?.image ?? productImg1),
          );
          if (wishlistController != null) {
            model.isFavorite.value = wishlistController.isFavorite(model.name);
          }
          return model;
        }).toList();
        products.assignAll(loaded);
      } else {
        products.clear();
      }
    } catch (e) {
      debugPrint('fetchRestaurantProducts error: $e');
      products.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategoryProducts(dynamic catId) async {
    final wishlistController = Get.isRegistered<WishlistController>()
        ? Get.find<WishlistController>()
        : null;
    try {
      isLoading.value = true;
      final response = await _getCategoryProductsUseCase(categoryId: catId);
      if (response.success && response.data.isNotEmpty) {
        if (response.categoryName != null && response.categoryName!.isNotEmpty) {
          title.value = '${response.categoryName!.capitalizeWords()} List';
        }
        final loaded = response.data.map((item) {
          final model = ProductModel(
            id: item.id.toString(),
            name: item.name.capitalizeWords(),
            type: item.type.capitalizeWords(),
            isVeg: item.isVeg,
            oldPrice: item.oldPrice > 0 ? item.oldPrice : item.price,
            newPrice: item.price,
            image: (item.image != null && item.image!.isNotEmpty)
                ? item.image!
                : productImg1,
          );
          if (wishlistController != null) {
            model.isFavorite.value = wishlistController.isFavorite(model.name);
          }
          return model;
        }).toList();
        products.assignAll(loaded);
      } else {
        products.clear();
      }
    } catch (e) {
      debugPrint('fetchCategoryProducts error: $e');
      products.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite(String id) {
    final index = products.indexWhere((p) => p.id == id);
    if (index != -1) {
      final product = products[index];
      final wishlistController = Get.find<WishlistController>();
      wishlistController.toggleProductFavorite(product);
    }
  }

  int getQuantity(ProductModel product) {
    if (Get.isRegistered<CartController>()) {
      final cartController = Get.find<CartController>();
      final cartItem = cartController.cartItems.firstWhereOrNull(
        (item) => item.id == product.id || item.name == product.name,
      );
      if (cartItem != null) {
        return cartItem.quantity.value;
      }
    }
    return 0;
  }

  void incrementQuantity(ProductModel product) {
    if (isRestaurantClosed.value) {
      Get.snackbar(
        'Restaurant Unavailable',
        'Cannot add items to cart while restaurant is closed.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (Get.isRegistered<CartController>()) {
      final cartController = Get.find<CartController>();
      final cartIndex = cartController.cartItems.indexWhere(
        (item) => item.name == product.name || item.id == product.id,
      );
      if (cartIndex != -1) {
        cartController.incrementQuantity(cartIndex);
      } else {
        cartController.addItem(
          id: product.id,
          name: product.name,
          type: product.type,
          isVeg: product.isVeg,
          oldPrice: product.oldPrice,
          newPrice: product.newPrice,
          image: product.image,
          quantity: 1,
        );
      }
    }
  }

  void decrementQuantity(ProductModel product) {
    if (isRestaurantClosed.value) {
      return;
    }

    if (Get.isRegistered<CartController>()) {
      final cartController = Get.find<CartController>();
      final cartIndex = cartController.cartItems.indexWhere(
        (item) => item.name == product.name || item.id == product.id,
      );
      if (cartIndex != -1) {
        cartController.decrementQuantity(cartIndex);
      }
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
    
    final index = products.indexWhere((p) => p.id == id);
    if (index != -1) {
      final product = products[index];
      incrementQuantity(product);
    }
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
