class ToggleWishlistResponseModel {
  final bool success;
  final String message;
  final dynamic data;
  final dynamic errors;
  final int? code;
  final bool? isWishlisted;

  ToggleWishlistResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.errors,
    this.code,
    this.isWishlisted,
  });

  factory ToggleWishlistResponseModel.fromJson(Map<String, dynamic> json) {
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

    bool? isFav;
    if (json['is_wishlisted'] != null) {
      isFav = json['is_wishlisted'] == true ||
          json['is_wishlisted'] == 1 ||
          json['is_wishlisted'] == '1';
    } else if (json['is_favorite'] != null) {
      isFav = json['is_favorite'] == true ||
          json['is_favorite'] == 1 ||
          json['is_favorite'] == '1';
    } else if (json['data'] is Map) {
      final d = json['data'] as Map;
      if (d['is_wishlisted'] != null) {
        isFav = d['is_wishlisted'] == true || d['is_wishlisted'] == 1;
      } else if (d['is_favorite'] != null) {
        isFav = d['is_favorite'] == true || d['is_favorite'] == 1;
      }
    }

    return ToggleWishlistResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      data: json['data'],
      errors: json['errors'],
      code: parsedCode,
      isWishlisted: isFav,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'errors': errors,
      if (code != null) 'code': code,
      if (isWishlisted != null) 'is_wishlisted': isWishlisted,
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
