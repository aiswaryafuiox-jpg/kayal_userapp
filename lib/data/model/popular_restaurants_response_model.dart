class PopularRestaurantsResponseModel {
  final bool success;
  final String message;
  final List<PopularRestaurantItemModel> data;
  final dynamic errors;

  PopularRestaurantsResponseModel({
    this.success = true,
    this.message = '',
    this.data = const [],
    this.errors,
  });

  factory PopularRestaurantsResponseModel.fromJson(Map<String, dynamic> json) {
    List<PopularRestaurantItemModel> parseList(dynamic rawList) {
      if (rawList is List) {
        return rawList
            .map((item) {
              if (item is Map<String, dynamic>) {
                return PopularRestaurantItemModel.fromJson(item);
              } else if (item is Map) {
                return PopularRestaurantItemModel.fromJson(
                  Map<String, dynamic>.from(item),
                );
              }
              return null;
            })
            .whereType<PopularRestaurantItemModel>()
            .toList();
      }
      return [];
    }

    List<PopularRestaurantItemModel> restaurantList = [];
    if (json['data'] != null) {
      if (json['data'] is List) {
        restaurantList = parseList(json['data']);
      } else if (json['data'] is Map<String, dynamic> &&
          json['data']['restaurants'] != null) {
        restaurantList = parseList(json['data']['restaurants']);
      } else if (json['data'] is Map<String, dynamic> &&
          json['data']['popular_restaurants'] != null) {
        restaurantList = parseList(json['data']['popular_restaurants']);
      }
    } else if (json['restaurants'] != null) {
      restaurantList = parseList(json['restaurants']);
    } else if (json['popular_restaurants'] != null) {
      restaurantList = parseList(json['popular_restaurants']);
    }

    return PopularRestaurantsResponseModel(
      success: json['success'] ?? true,
      message: json['message']?.toString() ?? '',
      data: restaurantList,
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

class PopularRestaurantItemModel {
  final dynamic id;
  final String name;
  final String? image;
  final String? cuisine;
  final String? deliveryTime;
  final String? distance;
  final String? openingTime;
  final bool isOpen;
  final dynamic rating;
  final String? address;

  PopularRestaurantItemModel({
    this.id,
    required this.name,
    this.image,
    this.cuisine,
    this.deliveryTime,
    this.distance,
    this.openingTime,
    this.isOpen = true,
    this.rating,
    this.address,
  });

  factory PopularRestaurantItemModel.fromJson(Map<String, dynamic> json) {
    return PopularRestaurantItemModel(
      id: json['id'] ?? json['restaurant_id'],
      name:
          json['name']?.toString() ?? json['restaurant_name']?.toString() ?? '',
      image:
          json['image']?.toString() ??
          json['image_url']?.toString() ??
          json['banner']?.toString() ??
          json['logo']?.toString(),
      cuisine:
          json['cuisine']?.toString() ??
          json['description']?.toString() ??
          json['category']?.toString(),
      deliveryTime:
          json['delivery_time']?.toString() ??
          json['estimated_time']?.toString() ??
          '25-30 mins',
      distance: json['distance']?.toString() ?? '2.8 Km',
      openingTime:
          json['opening_time']?.toString() ??
          json['timing']?.toString() ??
          '10:00 Am - 11:00 Pm',
      isOpen: json['is_open'] is bool
          ? json['is_open']
          : (json['is_open']?.toString() == '1' ||
                json['is_open']?.toString() == 'true' ||
                json['is_open'] == null),
      rating: json['rating'] ?? json['avg_rating'],
      address: json['address']?.toString() ?? json['location']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'cuisine': cuisine,
      'delivery_time': deliveryTime,
      'distance': distance,
      'opening_time': openingTime,
      'is_open': isOpen,
      'rating': rating,
      'address': address,
    };
  }
}
