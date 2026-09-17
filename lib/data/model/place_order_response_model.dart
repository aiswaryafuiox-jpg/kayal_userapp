class PlaceOrderDataModel {
  final String? orderId;
  final String? customOrderId;
  final double totalAmount;
  final String? paymentStatus;
  final String? estimatedDelivery;
  final String? status;

  PlaceOrderDataModel({
    this.orderId,
    this.customOrderId,
    this.totalAmount = 0.0,
    this.paymentStatus,
    this.estimatedDelivery,
    this.status,
  });

  factory PlaceOrderDataModel.fromJson(Map<String, dynamic> json) {
    return PlaceOrderDataModel(
      orderId: json['order_id']?.toString() ?? json['id']?.toString(),
      customOrderId: json['custom_order_id']?.toString() ??
          json['order_number']?.toString() ??
          json['order_no']?.toString(),
      totalAmount: _parseDouble(json['total_amount'] ?? json['amount']),
      paymentStatus: json['payment_status']?.toString(),
      estimatedDelivery: json['estimated_delivery']?.toString() ??
          json['estimated_delivery_time']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'custom_order_id': customOrderId,
      'total_amount': totalAmount,
      'payment_status': paymentStatus,
      'estimated_delivery': estimatedDelivery,
      'status': status,
    };
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      final sanitized = value.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(sanitized) ?? 0.0;
    }
    return 0.0;
  }
}

class PlaceOrderResponseModel {
  final bool success;
  final String message;
  final PlaceOrderDataModel? data;
  final dynamic errors;
  final int? code;

  PlaceOrderResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.errors,
    this.code,
  });

  // Backward compatibility & convenience getters
  dynamic get orderId => data?.orderId;
  String? get customOrderId => data?.customOrderId;
  String? get orderNumber => data?.customOrderId ?? data?.orderId;
  double get totalAmount => data?.totalAmount ?? 0.0;
  String? get paymentStatus => data?.paymentStatus;
  String? get estimatedDelivery => data?.estimatedDelivery;
  String? get status => data?.status;

  factory PlaceOrderResponseModel.fromJson(Map<String, dynamic> json) {
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

    PlaceOrderDataModel? parsedData;
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      parsedData = PlaceOrderDataModel.fromJson(json['data'] as Map<String, dynamic>);
    } else if (json['order'] != null && json['order'] is Map<String, dynamic>) {
      parsedData = PlaceOrderDataModel.fromJson(json['order'] as Map<String, dynamic>);
    } else if (json['order_id'] != null || json['custom_order_id'] != null) {
      parsedData = PlaceOrderDataModel.fromJson(json);
    }

    return PlaceOrderResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      data: parsedData,
      errors: json['errors'],
      code: parsedCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
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
