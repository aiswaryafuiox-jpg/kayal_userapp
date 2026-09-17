import 'package:kayal_userapp/core/const/app_images.dart';

class GetCartResponseModel {
  final bool success;
  final String message;
  final GetCartDataModel? data;
  final List<GetCartItemModel> items;
  final dynamic errors;
  final int? code;

  GetCartResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.items = const [],
    this.errors,
    this.code,
  });

  factory GetCartResponseModel.fromJson(Map<String, dynamic> json) {
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

    List<GetCartItemModel> parseItemsList(dynamic rawList) {
      if (rawList is List) {
        return rawList
            .map((item) {
              if (item is Map<String, dynamic>) {
                return GetCartItemModel.fromJson(item);
              } else if (item is Map) {
                return GetCartItemModel.fromJson(
                  Map<String, dynamic>.from(item),
                );
              }
              return null;
            })
            .whereType<GetCartItemModel>()
            .toList();
      }
      return [];
    }

    GetCartDataModel? parsedData;
    List<GetCartItemModel> parsedItems = [];

    if (json['data'] != null) {
      if (json['data'] is Map<String, dynamic>) {
        final dataMap = json['data'] as Map<String, dynamic>;
        parsedData = GetCartDataModel.fromJson(dataMap);
        if (dataMap['items'] != null) {
          parsedItems = parseItemsList(dataMap['items']);
        } else if (dataMap['cart_items'] != null) {
          parsedItems = parseItemsList(dataMap['cart_items']);
        } else if (dataMap['products'] != null) {
          parsedItems = parseItemsList(dataMap['products']);
        } else if (dataMap['cart'] != null && dataMap['cart'] is List) {
          parsedItems = parseItemsList(dataMap['cart']);
        }
      } else if (json['data'] is List) {
        parsedItems = parseItemsList(json['data']);
        parsedData = GetCartDataModel(items: parsedItems);
      }
    } else if (json['cart'] != null) {
      if (json['cart'] is Map<String, dynamic>) {
        parsedData = GetCartDataModel.fromJson(
          json['cart'] as Map<String, dynamic>,
        );
        if (json['cart']['items'] != null) {
          parsedItems = parseItemsList(json['cart']['items']);
        }
      } else if (json['cart'] is List) {
        parsedItems = parseItemsList(json['cart']);
        parsedData = GetCartDataModel(items: parsedItems);
      }
    } else if (json['items'] != null) {
      parsedItems = parseItemsList(json['items']);
      parsedData = GetCartDataModel(items: parsedItems);
    }

    return GetCartResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      data: parsedData,
      items: parsedItems.isNotEmpty ? parsedItems : (parsedData?.items ?? []),
      errors: json['errors'],
      code: parsedCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'items': items.map((e) => e.toJson()).toList(),
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

class GetCartDataModel {
  final List<GetCartItemModel> items;
  final double subTotal;
  final double totalAmount;
  final double discount;
  final double deliveryCharge;
  final double tax;
  final String? restaurantName;
  final dynamic restaurantId;

  GetCartDataModel({
    this.items = const [],
    this.subTotal = 0.0,
    this.totalAmount = 0.0,
    this.discount = 0.0,
    this.deliveryCharge = 0.0,
    this.tax = 0.0,
    this.restaurantName,
    this.restaurantId,
  });

  factory GetCartDataModel.fromJson(Map<String, dynamic> json) {
    List<GetCartItemModel> parsedItems = [];
    final rawItems =
        json['items'] ??
        json['cart_items'] ??
        json['products'] ??
        json['dishes'];
    if (rawItems is List) {
      parsedItems = rawItems
          .map((item) {
            if (item is Map<String, dynamic>) {
              return GetCartItemModel.fromJson(item);
            } else if (item is Map) {
              return GetCartItemModel.fromJson(Map<String, dynamic>.from(item));
            }
            return null;
          })
          .whereType<GetCartItemModel>()
          .toList();
    }

    final rawSubTotal =
        json['sub_total'] ?? json['subtotal'] ?? json['item_total'];
    final parsedSubTotal = rawSubTotal is num
        ? rawSubTotal.toDouble()
        : double.tryParse(rawSubTotal?.toString() ?? '0') ?? 0.0;

    final rawTotal =
        json['total_amount'] ??
        json['total'] ??
        json['grand_total'] ??
        json['net_amount'];
    final parsedTotal = rawTotal is num
        ? rawTotal.toDouble()
        : double.tryParse(rawTotal?.toString() ?? '0') ?? parsedSubTotal;

    final rawDiscount = json['discount'] ?? json['coupon_discount'];
    final parsedDiscount = rawDiscount is num
        ? rawDiscount.toDouble()
        : double.tryParse(rawDiscount?.toString() ?? '0') ?? 0.0;

    final rawDelivery =
        json['delivery_charge'] ?? json['delivery_fee'] ?? json['shipping_fee'];
    final parsedDelivery = rawDelivery is num
        ? rawDelivery.toDouble()
        : double.tryParse(rawDelivery?.toString() ?? '0') ?? 0.0;

    final rawTax = json['tax'] ?? json['tax_amount'] ?? json['gst'];
    final parsedTax = rawTax is num
        ? rawTax.toDouble()
        : double.tryParse(rawTax?.toString() ?? '0') ?? 0.0;

    return GetCartDataModel(
      items: parsedItems,
      subTotal: parsedSubTotal,
      totalAmount: parsedTotal > 0 ? parsedTotal : parsedSubTotal,
      discount: parsedDiscount,
      deliveryCharge: parsedDelivery,
      tax: parsedTax,
      restaurantName: json['restaurant_name']?.toString(),
      restaurantId: json['restaurant_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'sub_total': subTotal,
      'total_amount': totalAmount,
      'discount': discount,
      'delivery_charge': deliveryCharge,
      'tax': tax,
      if (restaurantName != null) 'restaurant_name': restaurantName,
      if (restaurantId != null) 'restaurant_id': restaurantId,
    };
  }
}

class GetCartItemModel {
  final dynamic id;
  final dynamic productId;
  final String name;
  final String type;
  final bool isVeg;
  final double oldPrice;
  final double newPrice;
  final String discount;
  final String image;
  final int quantity;

  GetCartItemModel({
    this.id,
    this.productId,
    this.name = '',
    this.type = 'Veg',
    this.isVeg = true,
    this.oldPrice = 0.0,
    this.newPrice = 0.0,
    this.discount = '20 %',
    this.image = '',
    this.quantity = 1,
  });

  factory GetCartItemModel.fromJson(Map<String, dynamic> json) {
    final rawPrice =
        json['price'] ??
        json['unit_price'] ??
        json['new_price'] ??
        json['offer_price'];
    final parsedPrice = rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice?.toString() ?? '0') ?? 0.0;

    final rawOldPrice =
        json['old_price'] ??
        json['mrp'] ??
        json['original_price'] ??
        parsedPrice;
    final parsedOldPrice = rawOldPrice is num
        ? rawOldPrice.toDouble()
        : double.tryParse(rawOldPrice?.toString() ?? '0') ?? parsedPrice;

    final rawQty = json['quantity'] ?? json['qty'] ?? json['count'] ?? 1;
    final parsedQty = rawQty is int
        ? rawQty
        : int.tryParse(rawQty?.toString() ?? '1') ?? 1;

    final rawType =
        json['type'] ?? json['food_type'] ?? json['category_name'] ?? 'Veg';
    final typeStr = rawType.toString();
    final bool isVegBool =
        json['is_veg'] == true ||
        json['is_veg'] == 1 ||
        json['is_veg'] == '1' ||
        typeStr.toLowerCase().contains('veg') &&
            !typeStr.toLowerCase().contains('non');

    final rawImage =
        json['image'] ??
        json['product_image'] ??
        json['image_url'] ??
        json['dish_image'] ??
        productImg3;

    final rawDiscount =
        json['discount'] ?? json['discount_percentage'] ?? json['offer'];
    final discountStr = rawDiscount != null ? rawDiscount.toString() : '20 %';

    return GetCartItemModel(
      id: json['id'] ?? json['cart_id'] ?? json['product_id'],
      productId: json['product_id'] ?? json['id'],
      name:
          json['name'] ?? json['product_name'] ?? json['title'] ?? 'Food Item',
      type: typeStr,
      isVeg: isVegBool,
      oldPrice: parsedOldPrice > 0 ? parsedOldPrice : parsedPrice,
      newPrice: parsedPrice,
      discount: discountStr.contains('%') ? discountStr : '$discountStr %',
      image: rawImage.toString(),
      quantity: parsedQty > 0 ? parsedQty : 1,
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
      'new_price': newPrice,
      'discount': discount,
      'image': image,
      'quantity': quantity,
    };
  }
}
