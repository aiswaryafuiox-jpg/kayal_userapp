class UpdateProfileDataModel {
  final String fullName;
  final String phone;
  final String email;
  final String address;
  final String? locationType;
  final String? profileImage;

  UpdateProfileDataModel({
    this.fullName = '',
    this.phone = '',
    this.email = '',
    this.address = '',
    this.locationType,
    this.profileImage,
  });

  factory UpdateProfileDataModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileDataModel(
      fullName: json['full_name']?.toString() ??
          json['name']?.toString() ??
          json['user_name']?.toString() ??
          '',
      phone: json['phone']?.toString() ??
          json['mobile']?.toString() ??
          json['phone_number']?.toString() ??
          '',
      email: json['email']?.toString() ?? '',
      address: json['address']?.toString() ??
          (json['default_address'] is Map
              ? (json['default_address']['text']?.toString() ?? '')
              : ''),
      locationType: json['location_type']?.toString() ??
          (json['default_address'] is Map
              ? json['default_address']['location_type']?.toString()
              : null),
      profileImage: json['profile_image']?.toString() ??
          json['image']?.toString() ??
          json['avatar']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'address': address,
      'location_type': locationType,
      'profile_image': profileImage,
    };
  }
}

class UpdateProfileResponseModel {
  final bool success;
  final String message;
  final UpdateProfileDataModel? data;
  final int? code;
  final dynamic errors;

  UpdateProfileResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.code,
    this.errors,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
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

    UpdateProfileDataModel? parsedData;
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      parsedData =
          UpdateProfileDataModel.fromJson(json['data'] as Map<String, dynamic>);
    } else if (json['data'] != null && json['data'] is Map) {
      parsedData = UpdateProfileDataModel.fromJson(
          Map<String, dynamic>.from(json['data']));
    }

    return UpdateProfileResponseModel(
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
