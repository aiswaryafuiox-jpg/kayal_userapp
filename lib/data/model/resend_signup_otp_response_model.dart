class ResendSignupOtpResponseModel {
  final bool success;
  final String message;
  final int code;
  final ResendSignupData? data;
  final dynamic errors;

  ResendSignupOtpResponseModel({
    required this.success,
    required this.message,
    required this.code,
    this.data,
    this.errors,
  });

  factory ResendSignupOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResendSignupOtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      code: json['code'] is int
          ? json['code']
          : int.tryParse(json['code']?.toString() ?? '0') ?? 0,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? ResendSignupData.fromJson(json['data'] as Map<String, dynamic>)
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

class ResendSignupData {
  final String tempUserId;
  final int expiresIn;
  final String otp;

  ResendSignupData({
    required this.tempUserId,
    required this.expiresIn,
    required this.otp,
  });

  factory ResendSignupData.fromJson(Map<String, dynamic> json) {
    return ResendSignupData(
      tempUserId: json['temp_user_id']?.toString() ?? '',
      expiresIn: json['expires_in'] is int
          ? json['expires_in']
          : int.tryParse(json['expires_in']?.toString() ?? '0') ?? 0,
      otp: json['otp']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp_user_id': tempUserId,
      'expires_in': expiresIn,
      'otp': otp,
    };
  }
}
