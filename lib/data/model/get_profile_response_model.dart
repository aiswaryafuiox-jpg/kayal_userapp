import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';

class ProfileDefaultAddressModel {

  final String text;
  final String locationType;

  ProfileDefaultAddressModel({this.text = '', this.locationType = 'Home'});

  factory ProfileDefaultAddressModel.fromJson(Map<String, dynamic> json) {
    return ProfileDefaultAddressModel(
      text: (json['text']?.toString() ?? '').capitalizeFirstLetter(),
      locationType:
          (json['location_type']?.toString() ??
                  json['type']?.toString() ??
                  'Home')
              .capitalizeWords(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'location_type': locationType};
  }
}

class ProfileDataModel {
  final String fullName;
  final String phone;
  final String email;
  final String? profileImage;
  final ProfileDefaultAddressModel? defaultAddress;

  ProfileDataModel({
    this.fullName = '',
    this.phone = '',
    this.email = '',
    this.profileImage,
    this.defaultAddress,
  });

  String get displayName => fullName.isNotEmpty ? fullName : 'User';

  String get displayPhone => phone.isNotEmpty ? phone : '';

  String get displayEmail => email.isNotEmpty ? email : '';

  String get avatarUrl => profileImage ?? '';

  bool get hasAvatar => profileImage != null && profileImage!.trim().isNotEmpty;

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) {
    ProfileDefaultAddressModel? parsedAddress;
    if (json['default_address'] != null &&
        json['default_address'] is Map<String, dynamic>) {
      parsedAddress = ProfileDefaultAddressModel.fromJson(
        json['default_address'] as Map<String, dynamic>,
      );
    } else if (json['default_address'] != null &&
        json['default_address'] is Map) {
      parsedAddress = ProfileDefaultAddressModel.fromJson(
        Map<String, dynamic>.from(json['default_address']),
      );
    }

    return ProfileDataModel(
      fullName:
          (json['full_name']?.toString() ??
                  json['name']?.toString() ??
                  json['user_name']?.toString() ??
                  '')
              .capitalizeWords(),
      phone:
          json['phone']?.toString() ??
          json['mobile']?.toString() ??
          json['phone_number']?.toString() ??
          '',
      email: json['email']?.toString() ?? '',
      profileImage:
          json['profile_image']?.toString() ??
          json['image']?.toString() ??
          json['avatar']?.toString(),
      defaultAddress: parsedAddress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'profile_image': profileImage,
      'default_address': defaultAddress?.toJson(),
    };
  }
}

class GetProfileResponseModel {
  final bool success;
  final String message;
  final ProfileDataModel? data;
  final int? code;
  final dynamic errors;

  GetProfileResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.code,
    this.errors,
  });

  factory GetProfileResponseModel.fromJson(Map<String, dynamic> json) {
    final rawSuccess = json['success'] ?? json['status'];
    final bool isSuccess =
        rawSuccess == true ||
        rawSuccess == 1 ||
        rawSuccess == '1' ||
        rawSuccess == 'true' ||
        rawSuccess == 'success';

    final rawCode = json['code'] ?? json['status_code'];
    final parsedCode = rawCode is int
        ? rawCode
        : int.tryParse(rawCode?.toString() ?? '');

    ProfileDataModel? parsedData;
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      parsedData = ProfileDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      );
    } else if (json['data'] != null && json['data'] is Map) {
      parsedData = ProfileDataModel.fromJson(
        Map<String, dynamic>.from(json['data']),
      );
    }

    return GetProfileResponseModel(
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
