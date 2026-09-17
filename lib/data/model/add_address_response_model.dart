import 'saved_address_response_model.dart';

class AddAddressResponseModel {
  final bool success;
  final String message;
  final SavedAddressModel? data;
  final dynamic errors;
  final int? code;

  AddAddressResponseModel({
    this.success = true,
    this.message = '',
    this.data,
    this.errors,
    this.code,
  });

  factory AddAddressResponseModel.fromJson(Map<String, dynamic> json) {
    final rawSuccess = json['success'] ?? json['status'];
    final bool isSuccess = rawSuccess == true ||
        rawSuccess == 1 ||
        rawSuccess == '1' ||
        rawSuccess == 'true' ||
        rawSuccess == 'success';

    SavedAddressModel? parsedAddress;
    if (json['data'] != null) {
      if (json['data'] is Map<String, dynamic>) {
        parsedAddress = SavedAddressModel.fromJson(json['data'] as Map<String, dynamic>);
      } else if (json['data'] is Map) {
        parsedAddress = SavedAddressModel.fromJson(
          Map<String, dynamic>.from(json['data'] as Map),
        );
      }
    } else if (json['address'] != null) {
      if (json['address'] is Map<String, dynamic>) {
        parsedAddress = SavedAddressModel.fromJson(json['address'] as Map<String, dynamic>);
      } else if (json['address'] is Map) {
        parsedAddress = SavedAddressModel.fromJson(
          Map<String, dynamic>.from(json['address'] as Map),
        );
      }
    }

    final rawCode = json['code'] ?? json['status_code'];
    final parsedCode = rawCode is int
        ? rawCode
        : int.tryParse(rawCode?.toString() ?? '');

    return AddAddressResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      data: parsedAddress,
      errors: json['errors'],
      code: parsedCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
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
