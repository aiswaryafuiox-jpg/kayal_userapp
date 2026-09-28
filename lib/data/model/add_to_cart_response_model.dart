class AddToCartResponseModel {
  final bool success;
  final String message;
  final AddToCartDataModel? data;
  final dynamic errors;

  AddToCartResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.errors,
  });

  factory AddToCartResponseModel.fromJson(Map<String, dynamic> json) {
    final rawSuccess = json['success'] ?? json['status'];
    final bool isSuccess = rawSuccess == true ||
        rawSuccess == 1 ||
        rawSuccess == '1' ||
        rawSuccess == 'true' ||
        rawSuccess == 'success';

    AddToCartDataModel? parsedData;
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      parsedData =
          AddToCartDataModel.fromJson(json['data'] as Map<String, dynamic>);
    } else if (json['data'] != null && json['data'] is Map) {
      parsedData = AddToCartDataModel.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      );
    } else if (json['cart'] != null && json['cart'] is Map) {
      parsedData = AddToCartDataModel.fromJson(
        Map<String, dynamic>.from(json['cart'] as Map),
      );
    }

    return AddToCartResponseModel(
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

class AddToCartDataModel {
  final CartItemDetailModel? cartItem;
  final int totalCartCount;
  final dynamic cartId;
  final dynamic productId;
  final int currentQuantity;
  final int totalCartItems;
  final double cartTotalAmount;

  AddToCartDataModel({
    this.cartItem,
    this.totalCartCount = 0,
    this.cartId,
    this.productId,
    this.currentQuantity = 0,
    this.totalCartItems = 0,
    this.cartTotalAmount = 0.0,
  });

  factory AddToCartDataModel.fromJson(Map<String, dynamic> json) {
    CartItemDetailModel? item;
    if (json['cart_item'] != null && json['cart_item'] is Map) {
      item = CartItemDetailModel.fromJson(
        Map<String, dynamic>.from(json['cart_item'] as Map),
      );
    }

    final rawCount = json['total_cart_count'] ?? json['total_cart_items'];
    final parsedCount = rawCount is int
        ? rawCount
        : int.tryParse(rawCount?.toString() ?? '0') ?? 0;

    final rawTotalAmount = json['cart_total_amount'] ?? json['total_amount'];
    final parsedTotalAmount = rawTotalAmount is num
        ? rawTotalAmount.toDouble()
        : double.tryParse(rawTotalAmount?.toString() ?? '0') ?? 0.0;

    return AddToCartDataModel(
      cartItem: item,
      totalCartCount: parsedCount,
      cartId: json['cart_id'] ?? json['id'],
      productId: json['product_id'],
      currentQuantity:
          int.tryParse(json['current_quantity']?.toString() ?? '') ?? 0,
      totalCartItems: parsedCount,
      cartTotalAmount: parsedTotalAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_item': cartItem?.toJson(),
      'total_cart_count': totalCartCount,
      'cart_id': cartId,
      'product_id': productId,
      'current_quantity': currentQuantity,
      'total_cart_items': totalCartItems,
      'cart_total_amount': cartTotalAmount,
    };
  }
}

class CartItemDetailModel {
  final dynamic id;
  final dynamic userId;
  final dynamic productId;
  final dynamic sessionId;
  final int quantity;

  CartItemDetailModel({
    this.id,
    this.userId,
    this.productId,
    this.sessionId,
    this.quantity = 1,
  });

  factory CartItemDetailModel.fromJson(Map<String, dynamic> json) {
    return CartItemDetailModel(
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      sessionId: json['session_id']?.toString(),
      quantity: int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'session_id': sessionId,
      'quantity': quantity,
    };
  }
}
