class SignupResponseModel {
  final bool success;
  final String message;
  final int code;
  final SignupData? data;
  final Map<String, dynamic>? errors;

  SignupResponseModel({
    required this.success,
    required this.message,
    required this.code,
    this.data,
    this.errors,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      code: json['code'] is int
          ? json['code']
          : int.tryParse(json['code']?.toString() ?? '0') ?? 0,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? SignupData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      errors: json['errors'] is Map<String, dynamic>
          ? json['errors'] as Map<String, dynamic>
          : null,
    );
  }

  String get formattedErrorMessage {
    if (errors != null && errors!.isNotEmpty) {
      final buffer = StringBuffer();
      errors!.forEach((key, value) {
        if (value is List && value.isNotEmpty) {
          buffer.writeln(value.first.toString());
        } else if (value != null) {
          buffer.writeln(value.toString());
        }
      });
      return buffer.toString().trim();
    }
    return message;
  }
}

class SignupData {
  final String tempUserId;
  final int expiresIn;
  final String otp;

  SignupData({
    required this.tempUserId,
    required this.expiresIn,
    required this.otp,
  });

  factory SignupData.fromJson(Map<String, dynamic> json) {
    return SignupData(
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
