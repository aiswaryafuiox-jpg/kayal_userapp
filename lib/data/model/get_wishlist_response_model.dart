import 'package:kayal_userapp/core/const/app_images.dart';

class GetWishlistResponseModel {
  final bool success;
  final String message;
  final List<WishlistItemModel> data;
  final dynamic errors;
  final int? code;

  GetWishlistResponseModel({
    this.success = true,
    this.message = '',
    this.data = const [],
    this.errors,
    this.code,
  });

  factory GetWishlistResponseModel.fromJson(Map<String, dynamic> json) {
    final rawSuccess = json['success'] ?? json['status'];
    final bool isSuccess =
        rawSuccess == true ||
        rawSuccess == 1 ||
        rawSuccess == '1' ||
        rawSuccess == 'true' ||
        rawSuccess == 'success';

    final rawCode = json['code'] ?? json['status_code'];
    final parsedCode = rawCode is int
        ? rawCode
        : int.tryParse(rawCode?.toString() ?? '');

    List<WishlistItemModel> items = [];

    List<WishlistItemModel> parseList(dynamic rawList) {
      if (rawList is List) {
        return rawList
            .map((item) {
              if (item is Map<String, dynamic>) {
                return WishlistItemModel.fromJson(item);
              } else if (item is Map) {
                return WishlistItemModel.fromJson(
                  Map<String, dynamic>.from(item),
                );
              }
              return null;
            })
            .whereType<WishlistItemModel>()
            .toList();
      }
      return [];
    }

    if (json['data'] != null) {
      if (json['data'] is List) {
        items = parseList(json['data']);
      } else if (json['data'] is Map<String, dynamic>) {
        final dataMap = json['data'] as Map<String, dynamic>;
        final rawList =
            dataMap['items'] ??
            dataMap['wishlist'] ??
            dataMap['products'] ??
            dataMap['favorite_items'];
        if (rawList != null) {
          items = parseList(rawList);
        }
      }
    } else if (json['wishlist'] != null) {
      items = parseList(json['wishlist']);
    } else if (json['items'] != null) {
      items = parseList(json['items']);
    } else if (json['products'] != null) {
      items = parseList(json['products']);
    }

    return GetWishlistResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      data: items,
      errors: json['errors'],
      code: parsedCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
      'errors': errors,
      if (code != null) 'code': code,
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
      if (errorList.isNotEmpty) {
        return errorList.join('\n');
      }
    }
    return message;
  }
}

class WishlistItemModel {
  final dynamic id;
  final dynamic productId;
  final String name;
  final String type;
  final bool isVeg;
  final double oldPrice;
  final double price;
  final String image;
  final String discount;

  WishlistItemModel({
    this.id,
    this.productId,
    this.name = '',
    this.type = 'Veg',
    this.isVeg = true,
    this.oldPrice = 0.0,
    this.price = 0.0,
    this.image = '',
    this.discount = '20 %',
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    final productMap = (json['product'] != null && json['product'] is Map)
        ? Map<String, dynamic>.from(json['product'])
        : json;

    final rawPrice =
        productMap['price'] ??
        productMap['new_price'] ??
        productMap['unit_price'] ??
        productMap['offer_price'] ??
        json['price'];
    final parsedPrice = rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice?.toString() ?? '0') ?? 0.0;

    final rawOldPrice =
        productMap['old_price'] ??
        productMap['mrp'] ??
        productMap['original_price'] ??
        json['old_price'] ??
        parsedPrice;
    final parsedOldPrice = rawOldPrice is num
        ? rawOldPrice.toDouble()
        : double.tryParse(rawOldPrice?.toString() ?? '0') ?? parsedPrice;

    final rawType =
        productMap['type'] ??
        productMap['category_name'] ??
        productMap['food_type'] ??
        json['type'] ??
        'Veg';
    final typeStr = rawType.toString();
    final bool isVegBool =
        productMap['is_veg'] == true ||
        productMap['is_veg'] == 1 ||
        productMap['is_veg'] == '1' ||
        json['is_veg'] == true ||
        (typeStr.toLowerCase().contains('veg') &&
            !typeStr.toLowerCase().contains('non'));

    final rawImage =
        productMap['image'] ??
        productMap['product_image'] ??
        productMap['image_url'] ??
        json['image'] ??
        productImg1;

    final rawDiscount =
        productMap['discount'] ??
        productMap['discount_percentage'] ??
        json['discount'];
    final discountStr = rawDiscount != null ? rawDiscount.toString() : '20 %';

    return WishlistItemModel(
      id: json['id'] ?? productMap['id'],
      productId: productMap['id'] ?? json['product_id'] ?? json['id'],
      name:
          (productMap['name'] ??
                  productMap['title'] ??
                  json['name'] ??
                  'Product')
              .toString(),
      type: typeStr,
      isVeg: isVegBool,
      oldPrice: parsedOldPrice > 0 ? parsedOldPrice : parsedPrice,
      price: parsedPrice,
      image: rawImage.toString(),
      discount: discountStr.contains('%') ? discountStr : '$discountStr %',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'type': type,
      'is_veg': isVeg,
      'old_price': oldPrice,
      'price': price,
      'image': image,
      'discount': discount,
    };
  }
}
