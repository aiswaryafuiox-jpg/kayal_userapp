import 'package:kayal_userapp/core/utils/helper/food_type_helper.dart';
import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';

class OrderSummaryResponseModel {

  final bool success;
  final String message;
  final OrderSummaryDataModel? data;
  final dynamic errors;

  OrderSummaryResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.errors,
  });

  factory OrderSummaryResponseModel.fromJson(Map<String, dynamic> json) {
    final rawSuccess = json['success'] ?? json['status'];
    final bool isSuccess = rawSuccess == true ||
        rawSuccess == 1 ||
        rawSuccess == '1' ||
        rawSuccess == 'true' ||
        rawSuccess == 'success';

    OrderSummaryDataModel? parsedData;
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      parsedData = OrderSummaryDataModel.fromJson(json['data'] as Map<String, dynamic>);
    } else if (json['data'] != null && json['data'] is Map) {
      parsedData = OrderSummaryDataModel.fromJson(Map<String, dynamic>.from(json['data'] as Map));
    } else if (json['data'] != null && json['data'] is List) {
      parsedData = OrderSummaryDataModel.fromList(json['data'] as List);
    } else if (json['cart'] != null && json['cart'] is Map<String, dynamic>) {
      parsedData = OrderSummaryDataModel.fromJson(json['cart'] as Map<String, dynamic>);
    } else if (json['items'] != null || json['total_amount'] != null || json['total'] != null) {
      parsedData = OrderSummaryDataModel.fromJson(json);
    }

    return OrderSummaryResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      data: parsedData,
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

class OrderSummaryDataModel {
  final List<OrderSummaryItemModel> items;
  final double subTotal;
  final double discount;
  final double deliveryCharge;
  final double tax;
  final double totalAmount;
  final String estimatedDeliveryTime;
  final String? restaurantName;
  final dynamic restaurantId;
  final String? specialInstructions;

  OrderSummaryDataModel({
    this.items = const [],
    this.subTotal = 0.0,
    this.discount = 0.0,
    this.deliveryCharge = 0.0,
    this.tax = 0.0,
    this.totalAmount = 0.0,
    this.estimatedDeliveryTime = '20-25 mins',
    this.restaurantName,
    this.restaurantId,
    this.specialInstructions,
  });

  factory OrderSummaryDataModel.fromJson(Map<String, dynamic> json) {
    List<OrderSummaryItemModel> parsedItems = [];
    final rawItems = json['items'] ??
        json['cart_items'] ??
        json['products'] ??
        json['order_items'] ??
        json['dishes'] ??
        json['data'];

    if (rawItems is List) {
      parsedItems = rawItems
          .map((item) => item is Map<String, dynamic>
              ? OrderSummaryItemModel.fromJson(item)
              : item is Map
                  ? OrderSummaryItemModel.fromJson(Map<String, dynamic>.from(item))
                  : null)
          .whereType<OrderSummaryItemModel>()
          .toList();
    }

    final rawSubTotal = json['sub_total'] ??
        json['subtotal'] ??
        json['item_total'] ??
        json['total_price'];
    final parsedSubTotal = rawSubTotal is num
        ? rawSubTotal.toDouble()
        : double.tryParse(rawSubTotal?.toString() ?? '0') ?? 0.0;

    final rawDiscount = json['discount'] ??
        json['offer_discount'] ??
        json['coupon_discount'] ??
        json['total_discount'];
    final parsedDiscount = rawDiscount is num
        ? rawDiscount.toDouble()
        : double.tryParse(rawDiscount?.toString() ?? '0') ?? 0.0;

    final rawDelivery = json['delivery_charge'] ??
        json['delivery_fee'] ??
        json['shipping_fee'] ??
        json['delivery_charges'];
    final parsedDelivery = rawDelivery is num
        ? rawDelivery.toDouble()
        : double.tryParse(rawDelivery?.toString() ?? '0') ?? 0.0;

    final rawTax = json['tax'] ??
        json['taxes'] ??
        json['gst'] ??
        json['tax_amount'];
    final parsedTax = rawTax is num
        ? rawTax.toDouble()
        : double.tryParse(rawTax?.toString() ?? '0') ?? 0.0;

    final rawTotal = json['total_amount'] ??
        json['total'] ??
        json['grand_total'] ??
        json['final_amount'] ??
        json['net_amount'] ??
        (parsedSubTotal - parsedDiscount + parsedDelivery + parsedTax);
    final parsedTotal = rawTotal is num
        ? rawTotal.toDouble()
        : double.tryParse(rawTotal?.toString() ?? '0') ?? (parsedSubTotal - parsedDiscount + parsedDelivery + parsedTax);

    return OrderSummaryDataModel(
      items: parsedItems,
      subTotal: parsedSubTotal > 0 ? parsedSubTotal : parsedTotal,
      discount: parsedDiscount,
      deliveryCharge: parsedDelivery,
      tax: parsedTax,
      totalAmount: parsedTotal > 0 ? parsedTotal : parsedSubTotal,
      estimatedDeliveryTime: json['estimated_delivery_time']?.toString() ??
          json['delivery_time']?.toString() ??
          json['estimate_time']?.toString() ??
          '20-25 mins',
      restaurantName: json['restaurant_name']?.toString().capitalizeWordsOrNull(),
      restaurantId: json['restaurant_id'],
      specialInstructions: (json['special_instructions']?.toString() ??
              json['instructions']?.toString())
          .capitalizeFirstLetterOrNull(),
    );
  }

  factory OrderSummaryDataModel.fromList(List list) {
    final parsedItems = list
        .map((item) => item is Map<String, dynamic>
            ? OrderSummaryItemModel.fromJson(item)
            : item is Map
                ? OrderSummaryItemModel.fromJson(Map<String, dynamic>.from(item))
                : null)
        .whereType<OrderSummaryItemModel>()
        .toList();

    double total = 0.0;
    for (var item in parsedItems) {
      total += (item.price * item.quantity);
    }

    return OrderSummaryDataModel(
      items: parsedItems,
      subTotal: total,
      totalAmount: total,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'sub_total': subTotal,
      'discount': discount,
      'delivery_charge': deliveryCharge,
      'tax': tax,
      'total_amount': totalAmount,
      'estimated_delivery_time': estimatedDeliveryTime,
      'restaurant_name': restaurantName,
      'restaurant_id': restaurantId,
      'special_instructions': specialInstructions,
    };
  }
}

class OrderSummaryItemModel {
  final dynamic id;
  final dynamic rawId;
  final dynamic productId;
  final String name;
  final String? image;
  final double price;
  final double oldPrice;
  final int quantity;
  final String type;
  final bool isVeg;
  final double totalPrice;
  final int foodType;

  OrderSummaryItemModel({
    this.id,
    this.rawId,
    this.productId,
    required this.name,
    this.image,
    this.price = 0.0,
    this.oldPrice = 0.0,
    this.quantity = 1,
    this.type = 'Non-Veg',
    this.isVeg = false,
    this.totalPrice = 0.0,
    this.foodType = 0,
  });

  factory OrderSummaryItemModel.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['sell_price'] ??
        json['price'] ??
        json['unit_price'] ??
        json['new_price'] ??
        json['offer_price'];
    final rawOldPrice = json['mrp'] ??
        json['old_price'] ??
        json['original_price'] ??
        rawPrice;
    final rawQuantity = json['quantity'] ?? json['qty'] ?? json['count'] ?? 1;

    final parsedPrice = rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice?.toString() ?? '0') ?? 0.0;

    final parsedOldPrice = rawOldPrice is num
        ? rawOldPrice.toDouble()
        : double.tryParse(rawOldPrice?.toString() ?? '0') ?? parsedPrice;

    final parsedQty = rawQuantity is num
        ? rawQuantity.toInt()
        : int.tryParse(rawQuantity?.toString() ?? '1') ?? 1;

    final rawName = (json['name']?.toString() ??
            json['product_name']?.toString() ??
            json['dish_name']?.toString() ??
            '')
        .capitalizeWords();

    final bool isVegProduct = FoodTypeHelper.determineIsVeg(
      foodType: json['food_type'],
      isVeg: json['is_veg'],
      vegStatus: json['veg_status'],
      type: json['type']?.toString(),
      productName: rawName,
    );

    final String typeStr = FoodTypeHelper.determineType(
      foodType: json['food_type'],
      isVeg: json['is_veg'],
      vegStatus: json['veg_status'],
      type: json['type']?.toString(),
      productName: rawName,
    );

    final rawTotalPrice = json['total'] ??
        json['total_price'] ??
        json['subtotal'] ??
        (parsedPrice * parsedQty);
    final parsedTotalPrice = rawTotalPrice is num
        ? rawTotalPrice.toDouble()
        : double.tryParse(rawTotalPrice?.toString() ?? '0') ??
            (parsedPrice * parsedQty);

    final rawFoodType = json['food_type'];
    final parsedFoodType = rawFoodType is int
        ? rawFoodType
        : int.tryParse(rawFoodType?.toString() ?? '0') ?? 0;

    return OrderSummaryItemModel(
      id: json['id'] ?? json['item_id'] ?? json['cart_id'],
      rawId: json['raw_id'],
      productId: json['product_id'] ?? json['dish_id'] ?? json['id'],
      name: rawName,
      image: json['image_url']?.toString() ??
          json['image']?.toString() ??
          json['photo']?.toString(),
      price: parsedPrice,
      oldPrice: parsedOldPrice,
      quantity: parsedQty,
      type: typeStr.capitalizeWords(),
      isVeg: isVegProduct,
      totalPrice: parsedTotalPrice,
      foodType: parsedFoodType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'raw_id': rawId,
      'product_id': productId,
      'name': name,
      'image_url': image,
      'image': image,
      'sell_price': price,
      'price': price,
      'mrp': oldPrice,
      'old_price': oldPrice,
      'quantity': quantity,
      'food_type': foodType,
      'type': type,
      'is_veg': isVeg,
      'total_price': totalPrice,
    };
  }
}
