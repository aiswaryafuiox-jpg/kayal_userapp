class SearchResponseModel {
  final bool success;
  final String message;
  final List<SearchRestaurantModel> restaurants;
  final List<SearchDishModel> dishes;
  final List<SearchCategoryModel> categories;
  final dynamic errors;

  SearchResponseModel({
    this.success = true,
    this.message = '',
    this.restaurants = const [],
    this.dishes = const [],
    this.categories = const [],
    this.errors,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    final dataMap = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return SearchResponseModel(
      success: json['success'] ?? true,
      message: json['message']?.toString() ?? '',
      restaurants: (dataMap['restaurants'] is List)
          ? (dataMap['restaurants'] as List)
              .map((e) => SearchRestaurantModel.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()
          : [],
      dishes: (dataMap['dishes'] is List)
          ? (dataMap['dishes'] as List)
              .map((e) => SearchDishModel.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()
          : [],
      categories: (dataMap['categories'] is List)
          ? (dataMap['categories'] as List)
              .map((e) => SearchCategoryModel.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()
          : [],
      errors: json['errors'],
    );
  }

  bool get isEmpty =>
      restaurants.isEmpty && dishes.isEmpty && categories.isEmpty;

  bool get isNotEmpty => !isEmpty;
}

class SearchRestaurantModel {
  final dynamic id;
  final String name;
  final String? image;
  final String? cuisine;
  final String? deliveryTime;
  final String? distance;
  final String? openingTime;
  final bool isOpen;

  SearchRestaurantModel({
    this.id,
    required this.name,
    this.image,
    this.cuisine,
    this.deliveryTime,
    this.distance,
    this.openingTime,
    this.isOpen = true,
  });

  factory SearchRestaurantModel.fromJson(Map<String, dynamic> json) {
    return SearchRestaurantModel(
      id: json['id'] ?? json['restaurant_id'],
      name: json['name']?.toString() ??
          json['restaurant_name']?.toString() ??
          '',
      image: json['image']?.toString() ?? json['banner']?.toString(),
      cuisine: json['cuisine']?.toString() ?? json['description']?.toString(),
      deliveryTime: json['delivery_time']?.toString() ??
          json['estimated_time']?.toString(),
      distance: json['distance']?.toString(),
      openingTime:
          json['opening_time']?.toString() ?? json['timing']?.toString(),
      isOpen: json['is_open'] is bool
          ? json['is_open']
          : (json['is_open']?.toString() == '1' ||
              json['is_open']?.toString() == 'true'),
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
    };
  }
}

class SearchDishModel {
  final dynamic id;
  final String name;
  final String? description;
  final String? image;
  final double price;
  final dynamic restaurantId;
  final String? restaurantName;

  SearchDishModel({
    this.id,
    required this.name,
    this.description,
    this.image,
    this.price = 0.0,
    this.restaurantId,
    this.restaurantName,
  });

  factory SearchDishModel.fromJson(Map<String, dynamic> json) {
    return SearchDishModel(
      id: json['id'] ?? json['dish_id'] ?? json['product_id'],
      name: json['name']?.toString() ??
          json['dish_name']?.toString() ??
          json['product_name']?.toString() ??
          '',
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      restaurantId: json['restaurant_id'],
      restaurantName: json['restaurant_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'restaurant_id': restaurantId,
      'restaurant_name': restaurantName,
    };
  }
}

class SearchCategoryModel {
  final dynamic id;
  final String name;
  final String? image;

  SearchCategoryModel({
    this.id,
    required this.name,
    this.image,
  });

  factory SearchCategoryModel.fromJson(Map<String, dynamic> json) {
    return SearchCategoryModel(
      id: json['id'] ?? json['category_id'],
      name: json['name']?.toString() ??
          json['category_name']?.toString() ??
          '',
      image: json['image']?.toString() ?? json['icon']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
