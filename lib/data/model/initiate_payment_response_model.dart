class InitiatePaymentResponseModel {
  final bool success;
  final String message;
  final InitiatePaymentDataModel? data;
  final dynamic errors;
  final int? code;

  InitiatePaymentResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.errors,
    this.code,
  });

  factory InitiatePaymentResponseModel.fromJson(Map<String, dynamic> json) {
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

    InitiatePaymentDataModel? parsedData;
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      parsedData = InitiatePaymentDataModel.fromJson(json['data'] as Map<String, dynamic>);
    } else if (json['data'] != null && json['data'] is Map) {
      parsedData = InitiatePaymentDataModel.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      );
    } else if (json['payment'] != null && json['payment'] is Map<String, dynamic>) {
      parsedData = InitiatePaymentDataModel.fromJson(json['payment'] as Map<String, dynamic>);
    } else if (json['payment_url'] != null || json['transaction_id'] != null || json['razorpay_order_id'] != null) {
      parsedData = InitiatePaymentDataModel.fromJson(json);
    }

    return InitiatePaymentResponseModel(
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

class InitiatePaymentDataModel {
  final dynamic orderId;
  final double? amount;
  final String? currency;
  final String? paymentUrl;
  final String? razorpayOrderId;
  final String? transactionId;
  final String? keyId;
  final String? status;
  final dynamic rawData;

  InitiatePaymentDataModel({
    this.orderId,
    this.amount,
    this.currency = 'INR',
    this.paymentUrl,
    this.razorpayOrderId,
    this.transactionId,
    this.keyId,
    this.status,
    this.rawData,
  });

  factory InitiatePaymentDataModel.fromJson(Map<String, dynamic> json) {
    final rawAmount = json['amount'] ?? json['total_amount'] ?? json['grand_total'];
    final parsedAmount = rawAmount is num
        ? rawAmount.toDouble()
        : double.tryParse(rawAmount?.toString() ?? '');

    return InitiatePaymentDataModel(
      orderId: json['order_id'] ?? json['id'],
      amount: parsedAmount,
      currency: json['currency']?.toString() ?? 'INR',
      paymentUrl: json['payment_url']?.toString() ?? json['url']?.toString() ?? json['redirect_url']?.toString(),
      razorpayOrderId: json['razorpay_order_id']?.toString() ?? json['razorpay_id']?.toString(),
      transactionId: json['transaction_id']?.toString() ?? json['txnid']?.toString(),
      keyId: json['key_id']?.toString() ?? json['razorpay_key']?.toString() ?? json['key']?.toString(),
      status: json['status']?.toString(),
      rawData: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (orderId != null) 'order_id': orderId,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (paymentUrl != null) 'payment_url': paymentUrl,
      if (razorpayOrderId != null) 'razorpay_order_id': razorpayOrderId,
      if (transactionId != null) 'transaction_id': transactionId,
      if (keyId != null) 'key_id': keyId,
      if (status != null) 'status': status,
    };
  }
}
