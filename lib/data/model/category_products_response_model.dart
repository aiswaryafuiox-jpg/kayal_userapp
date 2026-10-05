import 'package:kayal_userapp/core/utils/helper/food_type_helper.dart';
import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';

class CategoryProductsResponseModel {
  final bool success;
  final String message;
  final String? categoryName;
  final List<CategoryProductItemModel> data;
  final dynamic meta;
  final dynamic errors;
  final int? code;

  CategoryProductsResponseModel({
    this.success = true,
    this.message = '',
    this.categoryName,
    this.data = const [],
    this.meta,
    this.errors,
    this.code,
  });

  factory CategoryProductsResponseModel.fromJson(Map<String, dynamic> json) {
    List<CategoryProductItemModel> parseList(dynamic rawList) {
      if (rawList is List) {
        return rawList
            .map((item) {
              if (item is Map<String, dynamic>) {
                return CategoryProductItemModel.fromJson(item);
              } else if (item is Map) {
                return CategoryProductItemModel.fromJson(
                  Map<String, dynamic>.from(item),
                );
              }
              return null;
            })
            .whereType<CategoryProductItemModel>()
            .toList();
      }
      return [];
    }

    List<CategoryProductItemModel> productList = [];
    String? catName;
    dynamic metaData;

    if (json['data'] != null) {
      if (json['data'] is List) {
        productList = parseList(json['data']);
      } else if (json['data'] is Map<String, dynamic> || json['data'] is Map) {
        final dataMap = Map<String, dynamic>.from(json['data'] as Map);
        catName = dataMap['category_name']?.toString() ?? dataMap['name']?.toString();
        metaData = dataMap['meta'];
        if (dataMap['products'] != null) {
          productList = parseList(dataMap['products']);
        } else if (dataMap['dishes'] != null) {
          productList = parseList(dataMap['dishes']);
        }
      }
    } else if (json['products'] != null) {
      productList = parseList(json['products']);
    } else if (json['dishes'] != null) {
      productList = parseList(json['dishes']);
    }

    return CategoryProductsResponseModel(
      success: json['success'] ?? true,
      message: json['message']?.toString() ?? '',
      categoryName: catName,
      data: productList,
      meta: metaData ?? json['meta'],
      errors: json['errors'],
      code: json['code'] is int ? json['code'] : int.tryParse(json['code']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'category_name': categoryName,
      'data': data.map((e) => e.toJson()).toList(),
      'meta': meta,
      'errors': errors,
      'code': code,
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
      return errorList.join('\n');
    }
    return message;
  }
}

class CategoryProductItemModel {
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
  final dynamic rating;
  final dynamic status;

  CategoryProductItemModel({
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
    this.rating,
    this.status,
  });

  factory CategoryProductItemModel.fromJson(Map<String, dynamic> json) {
    final itemMap = (json['product'] != null && json['product'] is Map)
        ? Map<String, dynamic>.from(json['product'])
        : ((json['dish'] != null && json['dish'] is Map)
            ? Map<String, dynamic>.from(json['dish'])
            : json);

    final rawPrice =
        itemMap['sell_price'] ??
        itemMap['price'] ??
        itemMap['new_price'] ??
        itemMap['offer_price'] ??
        itemMap['dish_price'] ??
        itemMap['product_price'] ??
        json['sell_price'] ??
        json['price'];

    final rawOldPrice =
        itemMap['mrp'] ??
        itemMap['old_price'] ??
        itemMap['original_price'] ??
        itemMap['regular_price'] ??
        json['mrp'] ??
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

    final rawName = (itemMap['name']?.toString() ??
            itemMap['product_name']?.toString() ??
            itemMap['dish_name']?.toString() ??
            json['name']?.toString() ??
            '')
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

    return CategoryProductItemModel(
      id: itemMap['id'] ?? itemMap['product_id'] ?? itemMap['dish_id'] ?? json['id'],
      name: rawName,
      description: (itemMap['description']?.toString() ?? json['description']?.toString())
          ?.capitalizeFirstLetter(),
      image:
          itemMap['image']?.toString() ??
          itemMap['image_url']?.toString() ??
          itemMap['photo']?.toString() ??
          itemMap['banner']?.toString() ??
          json['image']?.toString(),
      price: finalPrice,
      oldPrice: finalOldPrice,
      type: typeStr.capitalizeWords(),
      isVeg: isVegProduct,
      categoryId: itemMap['category_id'] ?? json['category_id'],
      restaurantId: itemMap['restaurant_id'] ?? json['restaurant_id'],
      rating: itemMap['rating'] ?? itemMap['avg_rating'] ?? json['rating'],
      status: itemMap['status'] ?? itemMap['is_available'] ?? json['status'],
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
      'rating': rating,
      'status': status,
    };
  }
}
