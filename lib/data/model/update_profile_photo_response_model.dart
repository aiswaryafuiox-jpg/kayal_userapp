class UpdateProfilePhotoDataModel {
  final String photoUrl;

  UpdateProfilePhotoDataModel({this.photoUrl = ''});

  factory UpdateProfilePhotoDataModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfilePhotoDataModel(
      photoUrl: json['photo_url']?.toString() ??
          json['image_url']?.toString() ??
          json['profile_image']?.toString() ??
          json['url']?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo_url': photoUrl,
    };
  }
}

class UpdateProfilePhotoResponseModel {
  final bool success;
  final String message;
  final UpdateProfilePhotoDataModel? data;
  final int? code;
  final dynamic errors;

  UpdateProfilePhotoResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.code,
    this.errors,
  });

  String get photoUrl => data?.photoUrl ?? '';

  factory UpdateProfilePhotoResponseModel.fromJson(Map<String, dynamic> json) {
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

    UpdateProfilePhotoDataModel? parsedData;
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      parsedData = UpdateProfilePhotoDataModel.fromJson(
          json['data'] as Map<String, dynamic>);
    } else if (json['data'] != null && json['data'] is Map) {
      parsedData = UpdateProfilePhotoDataModel.fromJson(
          Map<String, dynamic>.from(json['data']));
    }

    return UpdateProfilePhotoResponseModel(
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
