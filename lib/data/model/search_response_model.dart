import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';
import 'package:kayal_userapp/core/utils/helper/food_type_helper.dart';

class SearchResponseModel {
  final bool success;
  final String message;
  final List<SearchRestaurantModel> restaurants;
  final List<SearchDishModel> dishes;
  final List<SearchCategoryModel> categories;
  final dynamic errors;

  SearchResponseModel({
    this.success = true,
    this.message = '',
    this.restaurants = const [],
    this.dishes = const [],
    this.categories = const [],
    this.errors,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    final dataMap = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return SearchResponseModel(
      success: json['success'] ?? true,
      message: json['message']?.toString() ?? '',
      restaurants: ((dataMap['restaurants'] is List)
          ? (dataMap['restaurants'] as List)
                .map(
                  (e) => SearchRestaurantModel.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : <SearchRestaurantModel>[])
        ..sort((a, b) => (b.isOpen ? 1 : 0).compareTo(a.isOpen ? 1 : 0)),
      dishes: (dataMap['dishes'] is List)
          ? (dataMap['dishes'] as List)
                .map(
                  (e) => SearchDishModel.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : [],
      categories: (dataMap['categories'] is List)
          ? (dataMap['categories'] as List)
                .map(
                  (e) => SearchCategoryModel.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList()
          : [],
      errors: json['errors'],
    );
  }

  bool get isEmpty =>
      restaurants.isEmpty && dishes.isEmpty && categories.isEmpty;

  bool get isNotEmpty => !isEmpty;
}

class SearchRestaurantModel {
  final dynamic id;
  final String name;
  final String? image;
  final String? cuisine;
  final String? deliveryTime;
  final String? distance;
  final String? openingTime;
  final bool isOpen;

  SearchRestaurantModel({
    this.id,
    required this.name,
    this.image,
    this.cuisine,
    this.deliveryTime,
    this.distance,
    this.openingTime,
    this.isOpen = true,
  });

  factory SearchRestaurantModel.fromJson(Map<String, dynamic> json) {
    final rawOpenState = json['is_open'] ??
        json['is_online'] ??
        json['open_status'] ??
        json['is_active'];
    bool parsedIsOpen = true;
    if (rawOpenState is bool) {
      parsedIsOpen = rawOpenState;
    } else if (rawOpenState != null) {
      final s = rawOpenState.toString().toLowerCase().trim();
      parsedIsOpen = s == '1' || s == 'true' || s == 'open' || s == 'opened';
    } else if (json['is_closed'] != null) {
      final s = json['is_closed'].toString().toLowerCase().trim();
      parsedIsOpen = !(s == '1' || s == 'true' || s == 'closed');
    } else if (json['status'] != null) {
      final s = json['status'].toString().toLowerCase().trim();
      if (s == 'closed' || s == '0' || s == 'false') {
        parsedIsOpen = false;
      }
    }

    final startTime = json['start_time']?.toString();
    final endTime = json['end_time']?.toString();

    return SearchRestaurantModel(
      id: json['id'] ?? json['restaurant_id'],
      name:
          (json['name']?.toString() ??
                  json['restaurant_name']?.toString() ??
                  '')
              .capitalizeWords(),
      image: json['image']?.toString() ?? json['banner']?.toString(),
      cuisine:
          (json['cuisine']?.toString() ??
                  json['restaurant_type']?.toString() ??
                  json['description']?.toString())
              ?.capitalizeWords(),
      deliveryTime:
          json['delivery_time']?.toString() ??
          json['estimated_time']?.toString() ??
          json['food_preparation_time']?.toString(),
      distance: json['distance']?.toString() ?? json['distance_km']?.toString(),
      openingTime:
          json['opening_time']?.toString() ??
          json['timing']?.toString() ??
          (startTime != null && endTime != null
              ? '$startTime - $endTime'
              : startTime),
      isOpen: parsedIsOpen,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'cuisine': cuisine,
      'delivery_time': deliveryTime,
      'distance': distance,
      'opening_time': openingTime,
      'is_open': isOpen,
    };
  }
}

class SearchDishModel {
  final dynamic id;
  final String name;
  final String? description;
  final String? image;
  final double price;
  final double oldPrice;
  final String type;
  final bool isVeg;
  final dynamic categoryId;
  final dynamic restaurantId;
  final String? restaurantName;

  SearchDishModel({
    this.id,
    required this.name,
    this.description,
    this.image,
    this.price = 0.0,
    this.oldPrice = 0.0,
    this.type = 'Veg',
    this.isVeg = true,
    this.categoryId,
    this.restaurantId,
    this.restaurantName,
  });

  factory SearchDishModel.fromJson(Map<String, dynamic> json) {
    final rawName =
        (json['name']?.toString() ??
                json['dish_name']?.toString() ??
                json['product_name']?.toString() ??
                '')
            .capitalizeWords();
    final rawPrice =
        json['sell_price'] ??
        json['price'] ??
        json['new_price'] ??
        json['offer_price'];
    final rawOldPrice =
        json['mrp'] ?? json['old_price'] ?? json['original_price'] ?? rawPrice;
    final price = rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice?.toString() ?? '0') ?? 0.0;
    final oldPrice = rawOldPrice is num
        ? rawOldPrice.toDouble()
        : double.tryParse(rawOldPrice?.toString() ?? '0') ?? price;
    final isVeg = FoodTypeHelper.determineIsVeg(
      foodType: json['food_type'],
      isVeg: json['is_veg'],
      vegStatus: json['veg_status'],
      type: json['type']?.toString(),
      productName: rawName,
    );

    return SearchDishModel(
      id: json['id'] ?? json['dish_id'] ?? json['product_id'],
      name: rawName,
      description: json['description']
          ?.toString()
          .capitalizeFirstLetterOrNull(),
      image: json['image']?.toString(),
      price: price > 0 ? price : oldPrice,
      oldPrice: oldPrice > 0 ? oldPrice : price,
      type: FoodTypeHelper.determineType(
        foodType: json['food_type'],
        isVeg: json['is_veg'],
        vegStatus: json['veg_status'],
        type: json['type']?.toString(),
        productName: rawName,
      ).capitalizeWords(),
      isVeg: isVeg,
      categoryId: json['category_id'],
      restaurantId: json['restaurant_id'],
      restaurantName: json['restaurant_name']
          ?.toString()
          .capitalizeWordsOrNull(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'old_price': oldPrice,
      'type': type,
      'is_veg': isVeg,
      'category_id': categoryId,
      'restaurant_id': restaurantId,
      'restaurant_name': restaurantName,
    };
  }
}

class SearchCategoryModel {
  final dynamic id;
  final String name;
  final String? image;

  SearchCategoryModel({this.id, required this.name, this.image});

  factory SearchCategoryModel.fromJson(Map<String, dynamic> json) {
    return SearchCategoryModel(
      id: json['id'] ?? json['category_id'],
      name:
          (json['name']?.toString() ?? json['category_name']?.toString() ?? '')
              .capitalizeWords(),
      image: json['image']?.toString() ?? json['icon']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }
}
