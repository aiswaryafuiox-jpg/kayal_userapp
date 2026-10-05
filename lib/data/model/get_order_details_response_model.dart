import 'package:kayal_userapp/core/utils/helper/food_type_helper.dart';
import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';

class OrderDetailsItemModel {

  final dynamic productId;
  final String name;
  final String foodType;
  final bool isVeg;
  final String? imageUrl;
  final int qty;
  final double mrp;
  final double sellPrice;

  OrderDetailsItemModel({
    this.productId,
    required this.name,
    this.foodType = 'Veg',
    this.isVeg = true,
    this.imageUrl,
    this.qty = 1,
    this.mrp = 0.0,
    this.sellPrice = 0.0,
  });

  factory OrderDetailsItemModel.fromJson(Map<String, dynamic> json) {
    final rawName = (json['name']?.toString() ?? json['product_name']?.toString() ?? '')
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

    return OrderDetailsItemModel(
      productId: json['product_id'] ?? json['id'],
      name: rawName,
      foodType: typeStr.capitalizeWords(),
      isVeg: isVegProduct,
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
      qty: json['qty'] is int
          ? json['qty']
          : int.tryParse(json['qty']?.toString() ?? json['quantity']?.toString() ?? '1') ?? 1,
      mrp: _parseDouble(json['mrp'] ?? json['original_price'] ?? json['old_price']),
      sellPrice: _parseDouble(json['sell_price'] ?? json['price'] ?? json['offer_price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'food_type': foodType,
      'image_url': imageUrl,
      'qty': qty,
      'mrp': mrp,
      'sell_price': sellPrice,
    };
  }

  static double _parseDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0.0;
  }
}

class OrderDetailsAddressModel {
  final String id;
  final String addressType;
  final String houseNo;
  final String street;
  final String landmark;
  final String fullAddress;
  final String phone;

  OrderDetailsAddressModel({
    this.id = '',
    this.addressType = 'Home',
    this.houseNo = '',
    this.street = '',
    this.landmark = '',
    this.fullAddress = '',
    this.phone = '',
  });

  factory OrderDetailsAddressModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsAddressModel(
      id: json['id']?.toString() ?? '',
      addressType: (json['address_type']?.toString() ?? json['type']?.toString() ?? 'Home')
          .capitalizeWords(),
      houseNo: (json['house_no']?.toString() ?? '').capitalizeWords(),
      street: (json['street']?.toString() ?? '').capitalizeWords(),
      landmark: (json['landmark']?.toString() ?? '').capitalizeWords(),
      fullAddress: (json['full_address']?.toString() ?? json['address']?.toString() ?? '')
          .capitalizeFirstLetter(),
      phone: json['phone']?.toString() ?? json['phone_number']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address_type': addressType,
      'house_no': houseNo,
      'street': street,
      'landmark': landmark,
      'full_address': fullAddress,
      'phone': phone,
    };
  }

  String get displayAddress {
    if (fullAddress.isNotEmpty) return fullAddress;
    final parts = [
      if (houseNo.isNotEmpty) houseNo,
      if (street.isNotEmpty) street,
      if (landmark.isNotEmpty) 'Near $landmark',
    ];
    return parts.join(', ');
  }
}

class OrderDetailsSummaryModel {
  final double itemTotal;
  final double discount;
  final double grandTotal;
  final double totalPaid;

  OrderDetailsSummaryModel({
    this.itemTotal = 0.0,
    this.discount = 0.0,
    this.grandTotal = 0.0,
    this.totalPaid = 0.0,
  });

  factory OrderDetailsSummaryModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsSummaryModel(
      itemTotal: _parseDouble(json['item_total'] ?? json['subtotal'] ?? json['sub_total']),
      discount: _parseDouble(json['discount']),
      grandTotal: _parseDouble(json['grand_total'] ?? json['total_amount'] ?? json['total']),
      totalPaid: _parseDouble(json['total_paid'] ?? json['paid_amount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_total': itemTotal,
      'discount': discount,
      'grand_total': grandTotal,
      'total_paid': totalPaid,
    };
  }

  static double _parseDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0.0;
  }
}

class OrderDetailsPaymentModel {
  final String method;
  final String status;

  OrderDetailsPaymentModel({
    this.method = 'cash_on_delivery',
    this.status = 'pending',
  });

  factory OrderDetailsPaymentModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsPaymentModel(
      method: json['method']?.toString() ?? json['payment_method']?.toString() ?? 'cash_on_delivery',
      status: json['status']?.toString() ?? json['payment_status']?.toString() ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'status': status,
    };
  }

  String get displayMethod {
    final m = method.toLowerCase();
    if (m.contains('cash') || m == 'cod') {
      return 'Cash on delivery';
    } else if (m.contains('online')) {
      return 'Paid online';
    }
    return method.split('_').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' ');
  }

  String get displayStatus {
    final s = status.toLowerCase();
    if (s == 'paid' || s == 'success') return 'Paid';
    if (s == 'pending') return 'Pending';
    if (s == 'failed') return 'Failed';
    if (status.isEmpty) return status;
    return '${status[0].toUpperCase()}${status.substring(1).toLowerCase()}';
  }
}

class OrderDetailsDataModel {
  final String orderId;
  final String customOrderId;
  final String orderDate;
  final List<OrderDetailsItemModel> items;
  final OrderDetailsAddressModel? deliveryAddress;
  final OrderDetailsSummaryModel? summary;
  final OrderDetailsPaymentModel? paymentDetails;

  OrderDetailsDataModel({
    required this.orderId,
    this.customOrderId = '',
    this.orderDate = '',
    this.items = const [],
    this.deliveryAddress,
    this.summary,
    this.paymentDetails,
  });

  factory OrderDetailsDataModel.fromJson(Map<String, dynamic> json) {
    List<OrderDetailsItemModel> parsedItems = [];
    if (json['items'] != null && json['items'] is List) {
      parsedItems = (json['items'] as List)
          .map((item) {
            if (item is Map<String, dynamic>) {
              return OrderDetailsItemModel.fromJson(item);
            } else if (item is Map) {
              return OrderDetailsItemModel.fromJson(Map<String, dynamic>.from(item));
            }
            return null;
          })
          .whereType<OrderDetailsItemModel>()
          .toList();
    }

    return OrderDetailsDataModel(
      orderId: json['order_id']?.toString() ?? json['id']?.toString() ?? '',
      customOrderId: json['custom_order_id']?.toString() ?? '',
      orderDate: json['order_date']?.toString() ?? json['date']?.toString() ?? '',
      items: parsedItems,
      deliveryAddress: json['delivery_address'] != null && json['delivery_address'] is Map
          ? OrderDetailsAddressModel.fromJson(Map<String, dynamic>.from(json['delivery_address']))
          : null,
      summary: json['summary'] != null && json['summary'] is Map
          ? OrderDetailsSummaryModel.fromJson(Map<String, dynamic>.from(json['summary']))
          : null,
      paymentDetails: json['payment_details'] != null && json['payment_details'] is Map
          ? OrderDetailsPaymentModel.fromJson(Map<String, dynamic>.from(json['payment_details']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'custom_order_id': customOrderId,
      'order_date': orderDate,
      'items': items.map((e) => e.toJson()).toList(),
      'delivery_address': deliveryAddress?.toJson(),
      'summary': summary?.toJson(),
      'payment_details': paymentDetails?.toJson(),
    };
  }
}

class GetOrderDetailsResponseModel {
  final bool success;
  final String message;
  final OrderDetailsDataModel? data;
  final int? code;
  final dynamic errors;

  GetOrderDetailsResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.code,
    this.errors,
  });

  factory GetOrderDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawSuccess = json['success'] ?? json['status'];
    final bool isSuccess = rawSuccess == true ||
        rawSuccess == 1 ||
        rawSuccess == '1' ||
        rawSuccess == 'true' ||
        rawSuccess == 'success';

    final rawCode = json['code'] ?? json['status_code'];
    final parsedCode = rawCode is int
        ? rawCode
        : int.tryParse(rawCode?.toString() ?? '');

    OrderDetailsDataModel? parsedData;
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      parsedData = OrderDetailsDataModel.fromJson(json['data'] as Map<String, dynamic>);
    } else if (json['data'] != null && json['data'] is Map) {
      parsedData = OrderDetailsDataModel.fromJson(Map<String, dynamic>.from(json['data']));
    }

    return GetOrderDetailsResponseModel(
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
