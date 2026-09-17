class CategoryProductsResponseModel {
  final bool success;
  final String message;
  final List<CategoryProductItemModel> data;
  final dynamic errors;

  CategoryProductsResponseModel({
    this.success = true,
    this.message = '',
    this.data = const [],
    this.errors,
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
    if (json['data'] != null) {
      if (json['data'] is List) {
        productList = parseList(json['data']);
      } else if (json['data'] is Map<String, dynamic> &&
          json['data']['products'] != null) {
        productList = parseList(json['data']['products']);
      } else if (json['data'] is Map<String, dynamic> &&
          json['data']['dishes'] != null) {
        productList = parseList(json['data']['dishes']);
      }
    } else if (json['products'] != null) {
      productList = parseList(json['products']);
    } else if (json['dishes'] != null) {
      productList = parseList(json['dishes']);
    }

    return CategoryProductsResponseModel(
      success: json['success'] ?? true,
      message: json['message']?.toString() ?? '',
      data: productList,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
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
    final rawPrice = json['price'] ?? json['new_price'] ?? json['offer_price'];
    final rawOldPrice =
        json['old_price'] ??
        json['original_price'] ??
        json['mrp'] ??
        json['regular_price'] ??
        rawPrice;

    final parsedPrice = rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice?.toString() ?? '0') ?? 0.0;

    final parsedOldPrice = rawOldPrice is num
        ? rawOldPrice.toDouble()
        : double.tryParse(rawOldPrice?.toString() ?? '0') ?? parsedPrice;

    final rawType =
        json['type']?.toString() ??
        json['food_type']?.toString() ??
        (json['is_veg'] == true ||
                json['is_veg']?.toString() == '1' ||
                json['veg_status']?.toString() == '1'
            ? 'Veg'
            : 'Non-Veg');

    final bool isVegProduct =
        rawType.toLowerCase().contains('veg') &&
            !rawType.toLowerCase().contains('non') ||
        json['is_veg'] == true ||
        json['is_veg']?.toString() == '1' ||
        json['veg_status']?.toString() == '1';

    return CategoryProductItemModel(
      id: json['id'] ?? json['product_id'] ?? json['dish_id'],
      name:
          json['name']?.toString() ??
          json['product_name']?.toString() ??
          json['dish_name']?.toString() ??
          '',
      description: json['description']?.toString(),
      image:
          json['image']?.toString() ??
          json['image_url']?.toString() ??
          json['photo']?.toString() ??
          json['banner']?.toString(),
      price: parsedPrice,
      oldPrice: parsedOldPrice,
      type: isVegProduct ? 'Veg' : 'Non-Veg',
      isVeg: isVegProduct,
      categoryId: json['category_id'],
      restaurantId: json['restaurant_id'],
      rating: json['rating'] ?? json['avg_rating'],
      status: json['status'] ?? json['is_available'],
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
