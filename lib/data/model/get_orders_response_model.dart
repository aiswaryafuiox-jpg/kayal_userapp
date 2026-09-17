class UserOrderItemModel {
  final String orderId;
  final String productName;
  final int foodType;
  final bool isVeg;
  final String type;
  final String date;
  final double totalAmount;
  final String rawStatus;
  final String? imageUrl;

  UserOrderItemModel({
    required this.orderId,
    required this.productName,
    this.foodType = 0,
    this.isVeg = true,
    this.type = 'Veg',
    required this.date,
    this.totalAmount = 0.0,
    required this.rawStatus,
    this.imageUrl,
  });

  factory UserOrderItemModel.fromJson(Map<String, dynamic> json) {
    final rawTotal = json['total_amount'] ?? json['amount'] ?? json['price'];
    final parsedTotal = rawTotal is num
        ? rawTotal.toDouble()
        : double.tryParse(rawTotal?.toString() ?? '0') ?? 0.0;

    final rawFoodType = json['food_type'];
    final parsedFoodType = rawFoodType is int
        ? rawFoodType
        : int.tryParse(rawFoodType?.toString() ?? '0') ?? 0;

    // Determine veg / non-veg
    final rawType = json['type']?.toString();
    final bool isVegProduct =
        (rawType != null &&
            rawType.toLowerCase().contains('veg') &&
            !rawType.toLowerCase().contains('non')) ||
        parsedFoodType == 1 ||
        json['is_veg'] == true ||
        json['is_veg']?.toString() == '1';

    return UserOrderItemModel(
      orderId:
          json['order_id']?.toString() ??
          json['id']?.toString() ??
          json['custom_order_id']?.toString() ??
          '',
      productName:
          json['product_name']?.toString() ??
          json['name']?.toString() ??
          json['title']?.toString() ??
          'Order',
      foodType: parsedFoodType,
      isVeg: isVegProduct,
      type: isVegProduct ? 'Veg' : 'Non-Veg',
      date: json['date']?.toString() ?? json['created_at']?.toString() ?? '',
      totalAmount: parsedTotal,
      rawStatus: json['status']?.toString() ?? 'PENDING',
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'product_name': productName,
      'food_type': foodType,
      'type': type,
      'date': date,
      'total_amount': totalAmount,
      'status': rawStatus,
      'image_url': imageUrl,
    };
  }

  /// Formatted title for display
  String get displayStatus {
    final s = rawStatus.toUpperCase().trim();
    switch (s) {
      case 'PENDING':
        return 'Pending';
      case 'FOOD_READY':
        return 'Food Ready';
      case 'OUT_FOR_DELIVERY':
      case 'OUT OF DELIVERY':
        return 'Out Of Delivery';
      case 'DELIVERED':
        return 'Delivered';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        // Capitalize first letters
        return s
            .split('_')
            .map((w) {
              if (w.isEmpty) return '';
              return '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}';
            })
            .join(' ');
    }
  }

  bool get isDelivered => rawStatus.toUpperCase() == 'DELIVERED';
  bool get isCancelled => rawStatus.toUpperCase() == 'CANCELLED';
  bool get isOutForDelivery =>
      rawStatus.toUpperCase() == 'OUT_FOR_DELIVERY' ||
      rawStatus.toUpperCase() == 'OUT OF DELIVERY';
  bool get isTrackable => !isDelivered && !isCancelled;
}

class GetOrdersDataModel {
  final List<UserOrderItemModel> orders;
  final int currentPage;
  final int lastPage;
  final int total;

  GetOrdersDataModel({
    this.orders = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
  });

  factory GetOrdersDataModel.fromJson(Map<String, dynamic> json) {
    List<UserOrderItemModel> parsedOrders = [];
    if (json['orders'] != null && json['orders'] is List) {
      parsedOrders = (json['orders'] as List)
          .map((item) {
            if (item is Map<String, dynamic>) {
              return UserOrderItemModel.fromJson(item);
            } else if (item is Map) {
              return UserOrderItemModel.fromJson(
                Map<String, dynamic>.from(item),
              );
            }
            return null;
          })
          .whereType<UserOrderItemModel>()
          .toList();
    }

    return GetOrdersDataModel(
      orders: parsedOrders,
      currentPage: json['current_page'] is int
          ? json['current_page']
          : int.tryParse(json['current_page']?.toString() ?? '1') ?? 1,
      lastPage: json['last_page'] is int
          ? json['last_page']
          : int.tryParse(json['last_page']?.toString() ?? '1') ?? 1,
      total: json['total'] is int
          ? json['total']
          : int.tryParse(json['total']?.toString() ?? '0') ??
                parsedOrders.length,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((e) => e.toJson()).toList(),
      'current_page': currentPage,
      'last_page': lastPage,
      'total': total,
    };
  }
}

class GetOrdersResponseModel {
  final bool success;
  final String message;
  final GetOrdersDataModel? data;
  final int? code;
  final dynamic errors;

  GetOrdersResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.code,
    this.errors,
  });

  factory GetOrdersResponseModel.fromJson(Map<String, dynamic> json) {
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

    GetOrdersDataModel? parsedData;
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      parsedData = GetOrdersDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      );
    } else if (json['data'] != null && json['data'] is List) {
      parsedData = GetOrdersDataModel(
        orders: (json['data'] as List)
            .map((e) => UserOrderItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }

    return GetOrdersResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      data: parsedData,
      code: parsedCode,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'code': code,
      'errors': errors,
    };
  }

  List<UserOrderItemModel> get orders => data?.orders ?? [];

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
