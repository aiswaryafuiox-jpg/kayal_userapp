class VerifyLoginOtpResponseModel {
  final bool success;
  final String message;
  final int code;
  final VerifyLoginData? data;
  final dynamic errors;

  VerifyLoginOtpResponseModel({
    required this.success,
    required this.message,
    required this.code,
    this.data,
    this.errors,
  });

  factory VerifyLoginOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyLoginOtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      code: json['code'] is int
          ? json['code']
          : int.tryParse(json['code']?.toString() ?? '0') ?? 0,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? VerifyLoginData.fromJson(json['data'] as Map<String, dynamic>)
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

class VerifyLoginData {
  final String token;
  final String userId;
  final bool isRegistered;

  VerifyLoginData({
    required this.token,
    required this.userId,
    required this.isRegistered,
  });

  factory VerifyLoginData.fromJson(Map<String, dynamic> json) {
    return VerifyLoginData(
      token: json['token']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      isRegistered: json['is_registered'] is bool
          ? json['is_registered']
          : json['is_registered']?.toString() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user_id': userId,
      'is_registered': isRegistered,
    };
  }
}
