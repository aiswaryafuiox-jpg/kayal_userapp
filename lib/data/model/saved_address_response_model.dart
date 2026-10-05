import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';

class SavedAddressResponseModel {

  final bool success;
  final String message;
  final List<SavedAddressModel> data;
  final dynamic errors;
  final int? code;

  SavedAddressResponseModel({
    this.success = true,
    this.message = '',
    this.data = const [],
    this.errors,
    this.code,
  });

  factory SavedAddressResponseModel.fromJson(Map<String, dynamic> json) {
    final rawSuccess = json['success'] ?? json['status'];
    final bool isSuccess = rawSuccess == true ||
        rawSuccess == 1 ||
        rawSuccess == '1' ||
        rawSuccess == 'true' ||
        rawSuccess == 'success';

    List<SavedAddressModel> parseAddressList(dynamic rawList) {
      if (rawList is List) {
        return rawList
            .map((item) {
              if (item is Map<String, dynamic>) {
                return SavedAddressModel.fromJson(item);
              } else if (item is Map) {
                return SavedAddressModel.fromJson(
                  Map<String, dynamic>.from(item),
                );
              }
              return null;
            })
            .whereType<SavedAddressModel>()
            .toList();
      }
      return [];
    }

    List<SavedAddressModel> addressList = [];
    if (json['data'] != null) {
      if (json['data'] is List) {
        addressList = parseAddressList(json['data']);
      } else if (json['data'] is Map<String, dynamic>) {
        final dataMap = json['data'] as Map<String, dynamic>;
        if (dataMap['addresses'] != null) {
          addressList = parseAddressList(dataMap['addresses']);
        } else if (dataMap['saved_addresses'] != null) {
          addressList = parseAddressList(dataMap['saved_addresses']);
        } else if (dataMap['address'] != null) {
          if (dataMap['address'] is List) {
            addressList = parseAddressList(dataMap['address']);
          } else if (dataMap['address'] is Map<String, dynamic>) {
            addressList = [SavedAddressModel.fromJson(dataMap['address'])];
          }
        } else {
          // If data is a single address object
          addressList = [SavedAddressModel.fromJson(dataMap)];
        }
      } else if (json['data'] is Map) {
        addressList = [
          SavedAddressModel.fromJson(Map<String, dynamic>.from(json['data'] as Map)),
        ];
      }
    } else if (json['addresses'] != null) {
      addressList = parseAddressList(json['addresses']);
    } else if (json['saved_addresses'] != null) {
      addressList = parseAddressList(json['saved_addresses']);
    }

    final rawCode = json['code'] ?? json['status_code'];
    final parsedCode = rawCode is int
        ? rawCode
        : int.tryParse(rawCode?.toString() ?? '');

    return SavedAddressResponseModel(
      success: isSuccess,
      message: json['message']?.toString() ?? '',
      data: addressList,
      errors: json['errors'],
      code: parsedCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
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

class SavedAddressModel {
  final dynamic id;
  final dynamic userId;
  final String name;
  final String phone;
  final String address;
  final String? addressLine2;
  final String? landmark;
  final String city;
  final String state;
  final String pincode;
  final String type;
  final bool isDefault;
  final double? latitude;
  final double? longitude;
  final String? createdAt;
  final String? updatedAt;

  SavedAddressModel({
    this.id,
    this.userId,
    this.name = '',
    this.phone = '',
    this.address = '',
    this.addressLine2,
    this.landmark,
    this.city = '',
    this.state = '',
    this.pincode = '',
    this.type = 'Home',
    this.isDefault = false,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  factory SavedAddressModel.fromJson(Map<String, dynamic> json) {
    final rawDefault = json['is_default'] ?? json['default'] ?? json['isDefault'];
    final bool isDefaultBool = rawDefault == true ||
        rawDefault == 1 ||
        rawDefault == '1' ||
        rawDefault == 'true';

    final rawLat = json['latitude'] ?? json['lat'];
    final parsedLat = rawLat is num
        ? rawLat.toDouble()
        : double.tryParse(rawLat?.toString() ?? '');

    final rawLng = json['longitude'] ?? json['long'] ?? json['lng'];
    final parsedLng = rawLng is num
        ? rawLng.toDouble()
        : double.tryParse(rawLng?.toString() ?? '');

    dynamic rawId = json['raw_id'] ?? json['id'];
    if (rawId == null || (rawId is String && int.tryParse(rawId) == null)) {
      if (json['address_id'] != null) {
        final parsedAddressId = int.tryParse(json['address_id'].toString().trim());
        if (parsedAddressId != null) {
          rawId = parsedAddressId;
        } else {
          rawId ??= json['raw_id'] ?? json['address_id'];
        }
      }
    }

    dynamic parsedId = rawId;
    if (parsedId != null) {
      if (parsedId is num) {
        parsedId = parsedId.toInt();
      } else {
        final str = parsedId.toString().trim();
        final directInt = int.tryParse(str);
        if (directInt != null) {
          parsedId = directInt;
        } else {
          final match = RegExp(r'\d+').firstMatch(str);
          if (match != null) {
            parsedId = int.tryParse(match.group(0)!) ?? parsedId;
          }
        }
      }
    }

    return SavedAddressModel(
      id: parsedId,
      userId: json['user_id'] ?? json['customer_id'],
      name: (json['name']?.toString() ??
              json['full_name']?.toString() ??
              json['recipient_name']?.toString() ??
              '')
          .capitalizeWords(),
      phone: json['phone']?.toString() ??
          json['phone_number']?.toString() ??
          json['mobile']?.toString() ??
          '',
      address: (json['address']?.toString() ??
              json['street_address']?.toString() ??
              json['address_line_1']?.toString() ??
              json['address1']?.toString() ??
              '')
          .capitalizeFirstLetter(),
      addressLine2: (json['address_line_2']?.toString() ??
              json['address2']?.toString())
          ?.capitalizeFirstLetter(),
      landmark: (json['landmark']?.toString() ?? json['near_by']?.toString())
          ?.capitalizeWords(),
      city: (json['city']?.toString() ?? '').capitalizeWords(),
      state: (json['state']?.toString() ?? '').capitalizeWords(),
      pincode: json['pincode']?.toString() ??
          json['pin_code']?.toString() ??
          json['postal_code']?.toString() ??
          json['zip']?.toString() ??
          '',
      type: (json['type']?.toString() ??
              json['address_type']?.toString() ??
              json['location_type']?.toString() ??
              'Home')
          .capitalizeWords(),
      isDefault: isDefaultBool,
      latitude: parsedLat,
      longitude: parsedLng,
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'phone_number': phone,
      'address': address,
      'address_line_2': addressLine2,
      'landmark': landmark,
      'city': city,
      'state': state,
      'pincode': pincode,
      'type': type,
      'is_default': isDefault,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }

  /// Formatted multi-line address representation
  String get formattedAddress {
    final List<String> parts = [];
    if (address.isNotEmpty) parts.add(address);
    if (landmark != null && landmark!.isNotEmpty) parts.add('Near $landmark');
    
    final cityStatePin = [
      if (city.isNotEmpty) city,
      if (state.isNotEmpty) state,
    ].join(', ');

    if (cityStatePin.isNotEmpty && pincode.isNotEmpty) {
      parts.add('$cityStatePin-$pincode');
    } else if (cityStatePin.isNotEmpty) {
      parts.add(cityStatePin);
    } else if (pincode.isNotEmpty) {
      parts.add(pincode);
    }

    if (parts.isEmpty) {
      return address;
    }
    return parts.join('\n');
  }

  /// Convert to simple map matching UI expectations
  Map<String, String> toDisplayMap() {
    return {
      'type': type.isNotEmpty ? type : 'Home',
      'address': formattedAddress.isNotEmpty ? formattedAddress : address,
    };
  }
}
