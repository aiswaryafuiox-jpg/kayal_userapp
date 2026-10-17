import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';

class OrderSummaryResponseModel {
  final bool success;
  final String message;
  final int? code;
  final OrderSummaryDataModel? data;
  final dynamic errors;

  OrderSummaryResponseModel({
    this.success = true,
    this.message = '',
    this.code,
    this.data,
    this.errors,
  });

  factory OrderSummaryResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderSummaryResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      code: (json['code'] as num?)?.toInt(),
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? OrderSummaryDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'code': code,
    'data': data?.toJson(),
    'errors': errors,
  };

  String get formattedErrorMessage {
    if (errors == null) return message;
    if (errors is String) return errors as String;
    if (errors is Map) {
      final list = <String>[];
      (errors as Map).forEach((_, v) {
        if (v is List) {
          list.addAll(v.map((e) => e.toString()));
        } else if (v != null) {
          list.add(v.toString());
        }
      });
      return list.isNotEmpty ? list.join('\n') : message;
    }
    return message;
  }
}

class OrderSummaryDataModel {
  final List<OrderSummaryItemModel> items;
  final String specialInstructions;
  final double subtotal;
  final double discount;
  final double totalAmount;
  final double deliveryCharge;
  final String estimatedDeliveryTime;

  OrderSummaryDataModel({
    this.items = const [],
    this.specialInstructions = '',
    this.subtotal = 0.0,
    this.discount = 0.0,
    this.totalAmount = 0.0,
    this.deliveryCharge = 0.0,
    this.estimatedDeliveryTime = '20-25 mins',
  });

  double get subTotal => subtotal;

  factory OrderSummaryDataModel.fromJson(Map<String, dynamic> json) {
    return OrderSummaryDataModel(
      items: (json['items'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => OrderSummaryItemModel.fromJson(e))
              .toList() ??
          (json['items'] as List<dynamic>?)
              ?.whereType<Map>()
              .map((e) => OrderSummaryItemModel.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
      specialInstructions: json['special_instructions']?.toString() ?? '',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      deliveryCharge: (json['delivery_charge'] as num?)?.toDouble() ?? 0.0,
      estimatedDeliveryTime:
          json['estimated_delivery_time']?.toString() ?? '20-25 mins',
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
    'special_instructions': specialInstructions,
    'subtotal': subtotal,
    'discount': discount,
    'total_amount': totalAmount,
    'delivery_charge': deliveryCharge,
    'estimated_delivery_time': estimatedDeliveryTime,
  };
}

class OrderSummaryItemModel {
  final dynamic productId;
  final dynamic rawId;
  final String name;
  final int foodType;
  final double mrp;
  final double sellPrice;
  final int quantity;
  final String imageUrl;

  final dynamic _id;
  final double? _totalPrice;
  final String? _type;
  final bool? _isVeg;

  OrderSummaryItemModel({
    this.productId,
    this.rawId,
    required this.name,
    this.foodType = 0,
    double? mrp,
    double? sellPrice,
    this.quantity = 1,
    String? imageUrl,
    // Optional compatibility parameters used when constructed manually:
    dynamic id,
    String? image,
    double? price,
    double? oldPrice,
    double? totalPrice,
    String? type,
    bool? isVeg,
  })  : mrp = mrp ?? oldPrice ?? 0.0,
        sellPrice = sellPrice ?? price ?? 0.0,
        imageUrl = imageUrl ?? image ?? '',
        _id = id,
        _totalPrice = totalPrice,
        _type = type,
        _isVeg = isVeg;

  dynamic get id => _id ?? productId;
  double get price => sellPrice;
  double get oldPrice => mrp > 0 ? mrp : sellPrice;
  String get image => imageUrl;
  bool get isVeg => _isVeg ?? (foodType == 0);
  String get type => _type ?? (isVeg ? 'Veg' : 'Non-Veg');
  double get totalPrice => _totalPrice ?? (sellPrice * quantity);

  factory OrderSummaryItemModel.fromJson(Map<String, dynamic> json) {
    return OrderSummaryItemModel(
      productId: json['product_id'] ?? json['id'],
      rawId: json['raw_id'],
      name: (json['name']?.toString() ?? '').capitalizeWords(),
      foodType: (json['food_type'] as num?)?.toInt() ?? 0,
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      sellPrice: (json['sell_price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      imageUrl: json['image_url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'raw_id': rawId,
    'name': name,
    'food_type': foodType,
    'mrp': mrp,
    'sell_price': sellPrice,
    'quantity': quantity,
    'image_url': imageUrl,
  };
}
