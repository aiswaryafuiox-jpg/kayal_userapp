import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';

class BannerResponseModel {

  final bool success;
  final String message;
  final List<BannerItemModel> data;
  final dynamic errors;

  BannerResponseModel({
    this.success = true,
    this.message = '',
    this.data = const [],
    this.errors,
  });

  factory BannerResponseModel.fromJson(Map<String, dynamic> json) {
    List<BannerItemModel> parseBannerList(dynamic rawList) {
      if (rawList is List) {
        return rawList
            .map((item) {
              if (item is Map<String, dynamic>) {
                return BannerItemModel.fromJson(item);
              } else if (item is Map) {
                return BannerItemModel.fromJson(
                  Map<String, dynamic>.from(item),
                );
              }
              return null;
            })
            .whereType<BannerItemModel>()
            .toList();
      }
      return [];
    }

    List<BannerItemModel> bannerList = [];
    if (json['data'] != null) {
      if (json['data'] is List) {
        bannerList = parseBannerList(json['data']);
      } else if (json['data'] is Map<String, dynamic> &&
          json['data']['banners'] != null) {
        bannerList = parseBannerList(json['data']['banners']);
      }
    } else if (json['banners'] != null) {
      bannerList = parseBannerList(json['banners']);
    }

    return BannerResponseModel(
      success: json['success'] ?? true,
      message: json['message']?.toString() ?? '',
      data: bannerList,
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

class BannerItemModel {
  final dynamic id;
  final String? title;
  final String? image;
  final String? link;
  final dynamic restaurantId;
  final dynamic categoryId;
  final dynamic status;
  final String? createdAt;
  final String? updatedAt;

  BannerItemModel({
    this.id,
    this.title,
    this.image,
    this.link,
    this.restaurantId,
    this.categoryId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BannerItemModel.fromJson(Map<String, dynamic> json) {
    return BannerItemModel(
      id: json['id'] ?? json['banner_id'],
      title: (json['title']?.toString() ?? json['name']?.toString())
          ?.capitalizeWords(),
      image:
          json['image']?.toString() ??
          json['image_url']?.toString() ??
          json['banner']?.toString() ??
          json['photo']?.toString(),
      link: json['link']?.toString() ?? json['url']?.toString(),
      restaurantId: json['restaurant_id'],
      categoryId: json['category_id'],
      status: json['status'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'link': link,
      'restaurant_id': restaurantId,
      'category_id': categoryId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
