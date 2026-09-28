class ResendLoginOtpResponseModel {
  final bool success;
  final String message;
  final int code;
  final ResendLoginOtpData? data;
  final dynamic errors;

  ResendLoginOtpResponseModel({
    required this.success,
    required this.message,
    required this.code,
    this.data,
    this.errors,
  });

  factory ResendLoginOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResendLoginOtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      code: json['code'] is int
          ? json['code']
          : int.tryParse(json['code']?.toString() ?? '0') ?? 0,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? ResendLoginOtpData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      errors: json['errors'],
    );
  }

  String get formattedErrorMessage {
    if (errors is Map<String, dynamic> && (errors as Map).isNotEmpty) {
      final buffer = StringBuffer();
      (errors as Map<String, dynamic>).forEach((key, value) {
        if (value is List && value.isNotEmpty) {
          buffer.writeln(value.first.toString());
        } else if (value != null) {
          buffer.writeln(value.toString());
        }
      });
      return buffer.toString().trim();
    } else if (errors is List && (errors as List).isNotEmpty) {
      return (errors as List).join('\n');
    }
    return message;
  }
}

class ResendLoginOtpData {
  final String? userId;
  final int expiresIn;
  final String otp;
  final bool? isVerified;

  ResendLoginOtpData({
    this.userId,
    required this.expiresIn,
    required this.otp,
    this.isVerified,
  });

  factory ResendLoginOtpData.fromJson(Map<String, dynamic> json) {
    return ResendLoginOtpData(
      userId: json['user_id']?.toString(),
      expiresIn: json['expires_in'] is int
          ? json['expires_in']
          : int.tryParse(json['expires_in']?.toString() ?? '0') ?? 0,
      otp: json['otp']?.toString() ?? '',
      isVerified: json['is_verified'] is bool
          ? json['is_verified']
          : (json['is_verified'] != null
              ? json['is_verified'].toString().toLowerCase() == 'true'
              : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'user_id': userId,
      'expires_in': expiresIn,
      'otp': otp,
      if (isVerified != null) 'is_verified': isVerified,
    };
  }
}
