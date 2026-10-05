import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';

class OffersResponseModel {

  final bool success;
  final String message;
  final List<OfferItemModel> data;
  final dynamic errors;

  OffersResponseModel({
    this.success = true,
    this.message = '',
    this.data = const [],
    this.errors,
  });

  factory OffersResponseModel.fromJson(Map<String, dynamic> json) {
    List<OfferItemModel> parseList(dynamic rawList) {
      if (rawList is List) {
        return rawList
            .map((item) {
              if (item is Map<String, dynamic>) {
                return OfferItemModel.fromJson(item);
              } else if (item is Map) {
                return OfferItemModel.fromJson(Map<String, dynamic>.from(item));
              }
              return null;
            })
            .whereType<OfferItemModel>()
            .toList();
      }
      return [];
    }

    List<OfferItemModel> offersList = [];
    if (json['data'] != null) {
      if (json['data'] is List) {
        offersList = parseList(json['data']);
      } else if (json['data'] is Map<String, dynamic> &&
          json['data']['offers'] != null) {
        offersList = parseList(json['data']['offers']);
      } else if (json['data'] is Map<String, dynamic> &&
          json['data']['coupons'] != null) {
        offersList = parseList(json['data']['coupons']);
      }
    } else if (json['offers'] != null) {
      offersList = parseList(json['offers']);
    } else if (json['coupons'] != null) {
      offersList = parseList(json['coupons']);
    }

    return OffersResponseModel(
      success: json['success'] ?? true,
      message: json['message']?.toString() ?? '',
      data: offersList,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
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
      return errorList.join('\n');
    }
    return message;
  }
}

class OfferItemModel {
  final dynamic id;
  final String? title;
  final String? code;
  final String? description;
  final dynamic discount;
  final String? discountType;
  final dynamic minOrderAmount;
  final dynamic maxDiscount;
  final String? validFrom;
  final String? validUntil;
  final String? image;
  final dynamic status;
  final String? terms;

  OfferItemModel({
    this.id,
    this.title,
    this.code,
    this.description,
    this.discount,
    this.discountType,
    this.minOrderAmount,
    this.maxDiscount,
    this.validFrom,
    this.validUntil,
    this.image,
    this.status,
    this.terms,
  });

  factory OfferItemModel.fromJson(Map<String, dynamic> json) {
    return OfferItemModel(
      id: json['id'] ?? json['offer_id'] ?? json['coupon_id'],
      title:
          (json['title']?.toString() ??
                  json['name']?.toString() ??
                  json['offer_title']?.toString())
              .capitalizeWordsOrNull(),
      code:
          json['code']?.toString() ??
          json['coupon_code']?.toString() ??
          json['promo_code']?.toString(),
      description: json['description']?.toString().capitalizeFirstLetterOrNull(),
      discount:
          json['discount'] ??
          json['discount_percentage'] ??
          json['discount_amount'] ??
          json['offer_percentage'],
      discountType:
          json['discount_type']?.toString() ?? json['type']?.toString(),
      minOrderAmount:
          json['min_order_amount'] ??
          json['min_order_value'] ??
          json['min_amount'],
      maxDiscount: json['max_discount'] ?? json['max_discount_amount'],
      validFrom:
          json['valid_from']?.toString() ?? json['start_date']?.toString(),
      validUntil:
          json['valid_until']?.toString() ??
          json['valid_to']?.toString() ??
          json['end_date']?.toString() ??
          json['expires_at']?.toString(),
      image:
          json['image']?.toString() ??
          json['image_url']?.toString() ??
          json['banner']?.toString() ??
          json['icon']?.toString(),
      status: json['status'] ?? json['is_active'],
      terms: json['terms']?.toString() ?? json['terms_conditions']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'code': code,
      'description': description,
      'discount': discount,
      'discount_type': discountType,
      'min_order_amount': minOrderAmount,
      'max_discount': maxDiscount,
      'valid_from': validFrom,
      'valid_until': validUntil,
      'image': image,
      'status': status,
      'terms': terms,
    };
  }
}
