import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';

class CategoriesResponseModel {

  final bool success;
  final String message;
  final List<CategoryModel> data;
  final dynamic errors;

  CategoriesResponseModel({
    this.success = true,
    this.message = '',
    this.data = const [],
    this.errors,
  });

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    List<CategoryModel> parseList(dynamic rawList) {
      if (rawList is List) {
        return rawList
            .map((item) {
              if (item is Map<String, dynamic>) {
                return CategoryModel.fromJson(item);
              } else if (item is Map) {
                return CategoryModel.fromJson(Map<String, dynamic>.from(item));
              }
              return null;
            })
            .whereType<CategoryModel>()
            .toList();
      }
      return [];
    }

    List<CategoryModel> categoryList = [];
    if (json['data'] != null) {
      if (json['data'] is List) {
        categoryList = parseList(json['data']);
      } else if (json['data'] is Map<String, dynamic> &&
          json['data']['categories'] != null) {
        categoryList = parseList(json['data']['categories']);
      }
    } else if (json['categories'] != null) {
      categoryList = parseList(json['categories']);
    }

    return CategoriesResponseModel(
      success: json['success'] ?? true,
      message: json['message']?.toString() ?? '',
      data: categoryList,
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

class CategoryModel {
  final dynamic id;
  final String name;
  final String? image;
  final String? description;
  final dynamic status;
  final String? createdAt;
  final String? updatedAt;

  CategoryModel({
    this.id,
    required this.name,
    this.image,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? json['category_id'],
      name:
          (json['name']?.toString() ?? json['category_name']?.toString() ?? '')
              .capitalizeWords(),
      image:
          json['image']?.toString() ??
          json['image_url']?.toString() ??
          json['icon']?.toString() ??
          json['banner']?.toString(),
      description: json['description']?.toString().capitalizeFirstLetterOrNull(),
      status: json['status'] ?? json['is_active'],
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
