import 'package:kayal_userapp/core/utils/helper/food_type_helper.dart';
import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';

class RestaurantProductsResponseModel {

  final bool success;
  final String message;
  final RestaurantInfoModel? restaurant;
  final CategoryInfoModel? category;
  final List<RestaurantProductItemModel> products;
  final dynamic errors;

  RestaurantProductsResponseModel({
    this.success = true,
    this.message = '',
    this.restaurant,
    this.category,
    this.products = const [],
    this.errors,
  });

  factory RestaurantProductsResponseModel.fromJson(Map<String, dynamic> json) {
    RestaurantInfoModel? parsedRestaurant;
    if (json['restaurant'] != null && json['restaurant'] is Map<String, dynamic>) {
      parsedRestaurant = RestaurantInfoModel.fromJson(
        json['restaurant'] as Map<String, dynamic>,
      );
    } else if (json['restaurant'] != null && json['restaurant'] is Map) {
      parsedRestaurant = RestaurantInfoModel.fromJson(
        Map<String, dynamic>.from(json['restaurant'] as Map),
      );
    } else if (json['restaurants'] is List && (json['restaurants'] as List).isNotEmpty) {
      final first = (json['restaurants'] as List).first;
      if (first is Map && first['restaurant'] != null && first['restaurant'] is Map) {
        parsedRestaurant = RestaurantInfoModel.fromJson(
          Map<String, dynamic>.from(first['restaurant'] as Map),
        );
      }
    }

    CategoryInfoModel? parsedCategory;
    if (json['category'] != null && json['category'] is Map<String, dynamic>) {
      parsedCategory = CategoryInfoModel.fromJson(
        json['category'] as Map<String, dynamic>,
      );
    } else if (json['category'] != null && json['category'] is Map) {
      parsedCategory = CategoryInfoModel.fromJson(
        Map<String, dynamic>.from(json['category'] as Map),
      );
    }

    List<RestaurantProductItemModel> parsedProducts = [];
    dynamic rawProducts = json['products'] ??
        (json['data'] is Map ? json['data']['products'] : json['data']);

    if (rawProducts == null && json['restaurants'] is List) {
      final List<dynamic> allProds = [];
      for (var r in (json['restaurants'] as List)) {
        if (r is Map && r['products'] is List) {
          allProds.addAll(r['products'] as List);
        }
      }
      rawProducts = allProds;
    }

    if (rawProducts is List) {
      parsedProducts = rawProducts
          .map((item) {
            if (item is Map<String, dynamic>) {
              return RestaurantProductItemModel.fromJson(item);
            } else if (item is Map) {
              return RestaurantProductItemModel.fromJson(
                Map<String, dynamic>.from(item),
              );
            }
            return null;
          })
          .whereType<RestaurantProductItemModel>()
          .toList();
    }

    return RestaurantProductsResponseModel(
      success: json['success'] ?? true,
      message: json['message']?.toString() ?? '',
      restaurant: parsedRestaurant,
      category: parsedCategory,
      products: parsedProducts,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (restaurant != null) 'restaurant': restaurant!.toJson(),
      if (category != null) 'category': category!.toJson(),
      'products': products.map((e) => e.toJson()).toList(),
      'errors': errors,
    };
  }

  String get formattedErrorMessage {
    if (errors == null) return message;
    if (errors is String) return errors as String;
    if (errors is Map) {
      final map = errors as Map;
      final errorList = <String>[];
      map.forEach((key, value) {
        if (value is List) {
          errorList.addAll(value.map((e) => e.toString()));
        } else if (value is String) {
          errorList.add(value);
        }
      });
      return errorList.isNotEmpty ? errorList.join('\n') : message;
    }
    return message;
  }
}

class RestaurantInfoModel {
  final dynamic id;
  final String restaurantId;
  final String name;

  RestaurantInfoModel({
    this.id,
    this.restaurantId = '',
    this.name = '',
  });

  factory RestaurantInfoModel.fromJson(Map<String, dynamic> json) {
    return RestaurantInfoModel(
      id: json['id'],
      restaurantId: json['restaurant_id']?.toString() ?? '',
      name: (json['name']?.toString() ?? '').capitalizeWords(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'name': name,
    };
  }
}

class CategoryInfoModel {
  final dynamic id;
  final String name;

  CategoryInfoModel({
    this.id,
    this.name = '',
  });

  factory CategoryInfoModel.fromJson(Map<String, dynamic> json) {
    return CategoryInfoModel(
      id: json['id'] ?? json['category_id'],
      name: (json['name']?.toString() ?? '').capitalizeWords(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class RestaurantProductItemModel {
  final dynamic id;
  final String name;
  final String? description;
  final double price;
  final double oldPrice;
  final String? image;
  final bool isActive;
  final String type;
  final bool isVeg;

  RestaurantProductItemModel({
    this.id,
    required this.name,
    this.description,
    this.price = 0.0,
    this.oldPrice = 0.0,
    this.image,
    this.isActive = true,
    this.type = 'Veg',
    this.isVeg = true,
  });

  factory RestaurantProductItemModel.fromJson(Map<String, dynamic> json) {
    final itemMap = (json['product'] != null && json['product'] is Map)
        ? Map<String, dynamic>.from(json['product'])
        : json;

    final rawPrice = itemMap['price'] ??
        itemMap['sell_price'] ??
        itemMap['new_price'] ??
        itemMap['offer_price'] ??
        json['price'];

    final rawOldPrice = itemMap['old_price'] ??
        itemMap['mrp'] ??
        itemMap['original_price'] ??
        json['old_price'] ??
        rawPrice;

    final parsedPrice = rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice?.toString() ?? '0') ?? 0.0;

    final parsedOldPrice = rawOldPrice is num
        ? rawOldPrice.toDouble()
        : double.tryParse(rawOldPrice?.toString() ?? '0') ?? parsedPrice;

    final double finalPrice = parsedPrice > 0 ? parsedPrice : parsedOldPrice;
    final double finalOldPrice =
        parsedOldPrice > 0 ? parsedOldPrice : finalPrice;

    final rawName = (itemMap['name']?.toString() ?? json['name']?.toString() ?? '')
        .capitalizeWords();

    final bool isVegProduct = FoodTypeHelper.determineIsVeg(
      foodType: itemMap['food_type'] ?? json['food_type'],
      isVeg: itemMap['is_veg'] ?? json['is_veg'],
      vegStatus: itemMap['veg_status'] ?? json['veg_status'],
      type: itemMap['type']?.toString() ?? json['type']?.toString(),
      productName: rawName,
    );

    final String typeStr = FoodTypeHelper.determineType(
      foodType: itemMap['food_type'] ?? json['food_type'],
      isVeg: itemMap['is_veg'] ?? json['is_veg'],
      vegStatus: itemMap['veg_status'] ?? json['veg_status'],
      type: itemMap['type']?.toString() ?? json['type']?.toString(),
      productName: rawName,
    );

    return RestaurantProductItemModel(
      id: itemMap['product_id'] ??
          itemMap['id'] ??
          json['product_id'] ??
          json['id'],
      name: rawName,
      description: (itemMap['description']?.toString() ??
              json['description']?.toString())
          ?.capitalizeFirstLetter(),
      price: finalPrice,
      oldPrice: finalOldPrice,
      image: itemMap['image']?.toString() ??
          itemMap['image_url']?.toString() ??
          json['image']?.toString(),
      isActive: itemMap['is_active'] == true ||
          itemMap['is_active']?.toString() == '1' ||
          itemMap['is_active'] == null,
      type: typeStr.capitalizeWords(),
      isVeg: isVegProduct,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'old_price': oldPrice,
      'image': image,
      'is_active': isActive,
      'type': type,
      'is_veg': isVeg,
    };
  }
}
