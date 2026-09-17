class ReOrderDataModel {
  final String? cartId;

  ReOrderDataModel({this.cartId});

  factory ReOrderDataModel.fromJson(Map<String, dynamic> json) {
    return ReOrderDataModel(
      cartId: json['cart_id']?.toString() ?? json['id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
    };
  }
}

class ReOrderResponseModel {
  final bool success;
  final String message;
  final ReOrderDataModel? data;
  final int? code;
  final dynamic errors;

  ReOrderResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.code,
    this.errors,
  });

  String? get cartId => data?.cartId;

  factory ReOrderResponseModel.fromJson(Map<String, dynamic> json) {
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

    ReOrderDataModel? parsedData;
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      parsedData = ReOrderDataModel.fromJson(json['data'] as Map<String, dynamic>);
    } else if (json['data'] != null && json['data'] is Map) {
      parsedData = ReOrderDataModel.fromJson(Map<String, dynamic>.from(json['data']));
    }

    return ReOrderResponseModel(
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
