import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/repository/category_products_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/get_category_products_usecase.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';
import 'package:kayal_userapp/presentation/controller/wishlist_controller.dart';
import 'package:kayal_userapp/presentation/controller/cart_controller.dart';

class ProductController extends GetxController {
  final GetCategoryProductsUseCase _getCategoryProductsUseCase;

  ProductController({GetCategoryProductsUseCase? getCategoryProductsUseCase})
      : _getCategoryProductsUseCase = getCategoryProductsUseCase ??
            (sl.isRegistered<GetCategoryProductsUseCase>()
                ? sl<GetCategoryProductsUseCase>()
                : GetCategoryProductsUseCase(
                    CategoryProductsRepositoryImpl(ApiService())));

  final products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final isRestaurantClosed = false.obs;
  final closedNotes =
      'This restaurant is currently unavailable.\nOpens today at 10:00 AM'.obs;
  final title = 'Product List'.obs;
  dynamic categoryId;

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
      if (currentArgs is RestaurantItem) {
        title.value = currentArgs.name;
        isRestaurantClosed.value = !currentArgs.isOpen;
        if (!currentArgs.isOpen) {
          closedNotes.value =
              'This restaurant is currently unavailable.\n${currentArgs.openingTime}';
        }
        if (currentArgs.id != null) {
          categoryId = currentArgs.id;
        }
      } else if (currentArgs is Map) {
        if (currentArgs['category'] != null) {
          title.value = '${currentArgs['category']} List';
        } else if (currentArgs['restaurant'] != null &&
            currentArgs['restaurant'] is RestaurantItem) {
          title.value = (currentArgs['restaurant'] as RestaurantItem).name;
        }
        if (currentArgs['categoryId'] != null) {
          categoryId = currentArgs['categoryId'];
        }
        if (currentArgs['isClosed'] != null) {
          isRestaurantClosed.value = currentArgs['isClosed'] == true;
        }
        if (currentArgs['notes'] != null) {
          closedNotes.value = currentArgs['notes'];
        }
        if (currentArgs['restaurant'] != null &&
            currentArgs['restaurant'] is RestaurantItem) {
          final RestaurantItem r = currentArgs['restaurant'];
          isRestaurantClosed.value = !r.isOpen;
          if (categoryId == null && r.id != null) {
            categoryId = r.id;
          }
          if (!r.isOpen) {
            closedNotes.value =
                'This restaurant is currently unavailable.\n${r.openingTime}';
          }
        }
      }

      if (categoryId != null &&
          (categoryId != oldCatId || products.isEmpty) &&
          !isLoading.value) {
        fetchCategoryProducts(categoryId);
      }
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
        final loaded = response.data.map((item) {
          final model = ProductModel(
            id: item.id.toString(),
            name: item.name,
            type: item.type,
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

  void _loadProducts() {
    if (categoryId != null) {
      fetchCategoryProducts(categoryId);
    } else {
      products.clear();
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
      final cartController = Get.find<CartController>();
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
