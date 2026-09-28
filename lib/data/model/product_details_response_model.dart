class ProductDetailsResponseModel {
  final bool success;
  final String message;
  final ProductDetailDataModel? data;
  final dynamic errors;

  ProductDetailsResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.errors,
  });

  factory ProductDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    ProductDetailDataModel? detail;

    if (json['data'] != null) {
      if (json['data'] is Map<String, dynamic>) {
        final dataMap = json['data'] as Map<String, dynamic>;
        if (dataMap['product'] != null &&
            dataMap['product'] is Map<String, dynamic>) {
          detail = ProductDetailDataModel.fromJson(
            dataMap['product'] as Map<String, dynamic>,
          );
        } else if (dataMap['dish'] != null &&
            dataMap['dish'] is Map<String, dynamic>) {
          detail = ProductDetailDataModel.fromJson(
            dataMap['dish'] as Map<String, dynamic>,
          );
        } else {
          detail = ProductDetailDataModel.fromJson(dataMap);
        }
      } else if (json['data'] is Map) {
        detail = ProductDetailDataModel.fromJson(
          Map<String, dynamic>.from(json['data'] as Map),
        );
      } else if (json['data'] is List && (json['data'] as List).isNotEmpty) {
        final first = (json['data'] as List).first;
        if (first is Map) {
          detail = ProductDetailDataModel.fromJson(
            Map<String, dynamic>.from(first),
          );
        }
      }
    } else if (json['product'] != null &&
        json['product'] is Map<String, dynamic>) {
      detail = ProductDetailDataModel.fromJson(
        json['product'] as Map<String, dynamic>,
      );
    } else if (json['dish'] != null && json['dish'] is Map<String, dynamic>) {
      detail = ProductDetailDataModel.fromJson(
        json['dish'] as Map<String, dynamic>,
      );
    } else if (json['id'] != null ||
        json['product_id'] != null ||
        json['name'] != null) {
      detail = ProductDetailDataModel.fromJson(json);
    }

    return ProductDetailsResponseModel(
      success: json['success'] ?? true,
      message: json['message']?.toString() ?? '',
      data: detail,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
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

class ProductDetailDataModel {
  final dynamic id;
  final dynamic rawId;
  final String name;
  final String? description;
  final String? image;
  final double price;
  final double oldPrice;
  final String? offerPercentage;
  final String type;
  final bool isVeg;
  final dynamic categoryId;
  final dynamic restaurantId;
  final dynamic rating;
  final dynamic status;
  final int foodType;
  final int cartQuantity;

  ProductDetailDataModel({
    this.id,
    this.rawId,
    required this.name,
    this.description,
    this.image,
    this.price = 0.0,
    this.oldPrice = 0.0,
    this.offerPercentage,
    this.type = 'Veg',
    this.isVeg = true,
    this.categoryId,
    this.restaurantId,
    this.rating,
    this.status,
    this.foodType = 0,
    this.cartQuantity = 0,
  });

  factory ProductDetailDataModel.fromJson(Map<String, dynamic> json) {
    final rawPrice =
        json['sell_price'] ??
        json['price'] ??
        json['new_price'] ??
        json['offer_price'] ??
        json['dish_price'] ??
        json['product_price'];
    final rawOldPrice =
        json['mrp'] ??
        json['old_price'] ??
        json['original_price'] ??
        json['regular_price'] ??
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

    final rawFoodType = json['food_type'];
    final parsedFoodType = rawFoodType is int
        ? rawFoodType
        : int.tryParse(rawFoodType?.toString() ?? '0') ?? 0;

    final rawType =
        json['type']?.toString() ??
        (rawFoodType != null
            ? (parsedFoodType == 1 ? 'Veg' : 'Non-Veg')
            : (json['is_veg'] == true ||
                    json['is_veg']?.toString() == '1' ||
                    json['veg_status']?.toString() == '1'
                ? 'Veg'
                : 'Non-Veg'));

    final bool isVegProduct =
        (rawType.toLowerCase().contains('veg') &&
            !rawType.toLowerCase().contains('non')) ||
        parsedFoodType == 1 ||
        json['is_veg'] == true ||
        json['is_veg']?.toString() == '1' ||
        json['veg_status']?.toString() == '1';

    String? offerText;
    if (json['offer_percentage'] != null) {
      final raw = json['offer_percentage'].toString().trim();
      offerText = raw.contains('%') ? raw : '$raw %';
    } else if (json['discount'] != null) {
      final raw = json['discount'].toString().trim();
      offerText = raw.contains('%') ? raw : '$raw %';
    } else if (json['offer'] != null) {
      offerText = json['offer'].toString();
    } else if (parsedOldPrice > parsedPrice && parsedOldPrice > 0) {
      final discount = (((parsedOldPrice - parsedPrice) / parsedOldPrice) * 100)
          .round();
      if (discount > 0) {
        offerText = '$discount %';
      }
    }

    final rawCartQty = json['cart_quantity'];
    final parsedCartQty = rawCartQty is int
        ? rawCartQty
        : int.tryParse(rawCartQty?.toString() ?? '0') ?? 0;

    return ProductDetailDataModel(
      id: json['product_id'] ?? json['id'] ?? json['dish_id'],
      rawId: json['raw_id'],
      name:
          json['name']?.toString() ??
          json['product_name']?.toString() ??
          json['dish_name']?.toString() ??
          '',
      description: json['description']?.toString(),
      image:
          json['image_url']?.toString() ??
          json['image']?.toString() ??
          json['photo']?.toString() ??
          json['banner']?.toString(),
      price: finalPrice,
      oldPrice: finalOldPrice,
      offerPercentage: offerText,
      type: isVegProduct ? 'Veg' : 'Non-Veg',
      isVeg: isVegProduct,
      categoryId: json['category_id'],
      restaurantId: json['restaurant_id'],
      rating: json['rating'] ?? json['avg_rating'],
      status: json['status'] ?? json['is_available'],
      foodType: parsedFoodType,
      cartQuantity: parsedCartQty,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'raw_id': rawId,
      'name': name,
      'description': description,
      'image_url': image,
      'sell_price': price,
      'mrp': oldPrice,
      'offer_percentage': offerPercentage,
      'food_type': foodType,
      'type': type,
      'is_veg': isVeg,
      'category_id': categoryId,
      'restaurant_id': restaurantId,
      'rating': rating,
      'status': status,
      'cart_quantity': cartQuantity,
    };
  }
}
