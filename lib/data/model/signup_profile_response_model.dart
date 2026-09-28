class SignupProfileResponseModel {
  final bool success;
  final String message;
  final int? code;
  final SignupProfileData? data;
  final dynamic errors;

  SignupProfileResponseModel({
    required this.success,
    required this.message,
    this.code,
    this.data,
    this.errors,
  });

  factory SignupProfileResponseModel.fromJson(Map<String, dynamic> json) {
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

    return SignupProfileResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      code: parsedCode,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? SignupProfileData.fromJson(json['data'] as Map<String, dynamic>)
          : (json['data'] != null && json['data'] is Map
              ? SignupProfileData.fromJson(
                  Map<String, dynamic>.from(json['data']))
              : null),
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (code != null) 'code': code,
      'data': data?.toJson(),
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
    } else if (errors is List && (errors as List).isNotEmpty) {
      return (errors as List).join('\n');
    }
    return message;
  }
}

class SignupProfileData {
  final String? id;
  final String fullName;
  final String? phone;
  final String? email;

  SignupProfileData({
    this.id,
    this.fullName = '',
    this.phone,
    this.email,
  });

  factory SignupProfileData.fromJson(Map<String, dynamic> json) {
    return SignupProfileData(
      id: json['id']?.toString() ?? json['user_id']?.toString(),
      fullName: json['full_name']?.toString() ??
          json['name']?.toString() ??
          json['user_name']?.toString() ??
          '',
      phone: json['phone']?.toString() ??
          json['mobile']?.toString() ??
          json['phone_number']?.toString(),
      email: json['email']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
    };
  }
}
