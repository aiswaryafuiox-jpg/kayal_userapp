class ClearCartResponseModel {
  final bool success;
  final String message;
  final dynamic data;
  final dynamic errors;
  final int? code;

  ClearCartResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.errors,
    this.code,
  });

  factory ClearCartResponseModel.fromJson(Map<String, dynamic> json) {
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

    return ClearCartResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      data: json['data'] ?? json['cart'],
      errors: json['errors'],
      code: parsedCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
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
