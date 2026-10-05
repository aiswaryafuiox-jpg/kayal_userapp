import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';

class PopularRestaurantsResponseModel {

  final bool success;
  final String message;
  final String selectedCategory;
  final List<PopularRestaurantItemModel> data;
  final List<PopularRestaurantItemModel> within20Km;
  final List<PopularRestaurantItemModel> within40Km;
  final List<PopularRestaurantItemModel> within60Km;
  final List<PopularRestaurantItemModel> allRestaurants;
  final dynamic errors;

  PopularRestaurantsResponseModel({
    this.success = true,
    this.message = '',
    this.selectedCategory = '',
    this.data = const [],
    this.within20Km = const [],
    this.within40Km = const [],
    this.within60Km = const [],
    this.allRestaurants = const [],
    this.errors,
  });

  factory PopularRestaurantsResponseModel.fromJson(Map<String, dynamic> json) {
    final String selCategory =
        json['selected_category']?.toString() ??
        json['category']?.toString() ??
        '';

    List<PopularRestaurantItemModel> parseList(dynamic rawList) {
      if (rawList is List) {
        return rawList
            .map((item) {
              if (item is Map<String, dynamic>) {
                return PopularRestaurantItemModel.fromJson(
                  item,
                  fallbackCategory: selCategory,
                );
              } else if (item is Map) {
                return PopularRestaurantItemModel.fromJson(
                  Map<String, dynamic>.from(item),
                  fallbackCategory: selCategory,
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
    List<PopularRestaurantItemModel> w20 = [];
    List<PopularRestaurantItemModel> w40 = [];
    List<PopularRestaurantItemModel> w60 = [];
    List<PopularRestaurantItemModel> allRest = [];

    dynamic targetRestaurants = json['restaurants'] ?? json['popular_restaurants'];
    if (targetRestaurants == null && json['data'] != null) {
      if (json['data'] is Map<String, dynamic>) {
        targetRestaurants =
            json['data']['restaurants'] ?? json['data']['popular_restaurants'];
      } else if (json['data'] is List) {
        restaurantList = parseList(json['data']);
      }
    }

    if (targetRestaurants is Map) {
      final map = Map<String, dynamic>.from(targetRestaurants);
      w20 = parseList(map['within_20_km']);
      w40 = parseList(map['within_40_km']);
      w60 = parseList(map['within_60_km']);
      allRest = parseList(map['all_restaurants']);

      final Set<dynamic> seenIds = {};
      final List<PopularRestaurantItemModel> combined = [];

      void addDistinct(List<PopularRestaurantItemModel> list) {
        for (final item in list) {
          final idKey = item.id ?? item.name;
          if (!seenIds.contains(idKey)) {
            seenIds.add(idKey);
            combined.add(item);
          }
        }
      }

      addDistinct(w20);
      addDistinct(w40);
      addDistinct(w60);

      if (combined.isEmpty) {
        addDistinct(allRest);
      }

      // If still empty, check all other map lists
      if (combined.isEmpty) {
        for (final val in map.values) {
          if (val is List) {
            addDistinct(parseList(val));
          }
        }
      }

      restaurantList = combined;
    } else if (targetRestaurants is List) {
      restaurantList = parseList(targetRestaurants);
      allRest = restaurantList;
    }

    return PopularRestaurantsResponseModel(
      success: json['success'] ?? true,
      message: json['message']?.toString() ?? '',
      selectedCategory: selCategory,
      data: restaurantList,
      within20Km: w20,
      within40Km: w40,
      within60Km: w60,
      allRestaurants: allRest,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'selected_category': selectedCategory,
      'data': data.map((e) => e.toJson()).toList(),
      'restaurants': {
        'within_20_km': within20Km.map((e) => e.toJson()).toList(),
        'within_40_km': within40Km.map((e) => e.toJson()).toList(),
        'within_60_km': within60Km.map((e) => e.toJson()).toList(),
        'all_restaurants': allRestaurants.map((e) => e.toJson()).toList(),
      },
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
  final String? restaurantId;
  final String name;
  final String? image;
  final String? cuisine;
  final String? deliveryTime;
  final String? distance;
  final double? distanceKm;
  final String? openTime;
  final String? closeTime;
  final String? openingTime;
  final bool isOpen;
  final bool freeDelivery;
  final dynamic rating;
  final String? address;

  PopularRestaurantItemModel({
    this.id,
    this.restaurantId,
    required this.name,
    this.image,
    this.cuisine,
    this.deliveryTime,
    this.distance,
    this.distanceKm,
    this.openTime,
    this.closeTime,
    this.openingTime,
    this.isOpen = true,
    this.freeDelivery = false,
    this.rating,
    this.address,
  });

  factory PopularRestaurantItemModel.fromJson(
    Map<String, dynamic> json, {
    String? fallbackCategory,
  }) {
    final rawDistanceKm = json['distance_km'];
    double? parsedDistanceKm;
    if (rawDistanceKm != null) {
      parsedDistanceKm = double.tryParse(rawDistanceKm.toString());
    }

    String? computedDistance = json['distance']?.toString();
    if (computedDistance == null || computedDistance.isEmpty) {
      if (parsedDistanceKm != null) {
        computedDistance = '$parsedDistanceKm Km';
      } else {
        computedDistance = '2.8 Km';
      }
    }

    final openT = json['open_time']?.toString();
    final closeT = json['close_time']?.toString();
    String? computedOpeningTime =
        json['opening_time']?.toString() ?? json['timing']?.toString();
    if ((computedOpeningTime == null || computedOpeningTime.isEmpty) &&
        openT != null &&
        closeT != null &&
        openT.isNotEmpty &&
        closeT.isNotEmpty) {
      computedOpeningTime = '$openT - $closeT';
    }
    computedOpeningTime ??= '10:00 Am - 11:00 Pm';

    String? computedCuisine = json['cuisine']?.toString() ??
        json['description']?.toString() ??
        json['category']?.toString();
    if ((computedCuisine == null || computedCuisine.isEmpty) &&
        fallbackCategory != null &&
        fallbackCategory.isNotEmpty &&
        fallbackCategory.toLowerCase() != 'all') {
      computedCuisine = '$fallbackCategory Special';
    }

    final rawIsOpen = json['is_open'];
    bool parsedIsOpen = true;
    if (rawIsOpen is bool) {
      parsedIsOpen = rawIsOpen;
    } else if (rawIsOpen != null) {
      final s = rawIsOpen.toString().toLowerCase();
      parsedIsOpen = s == '1' || s == 'true';
    }

    final rawFreeDelivery = json['free_delivery'];
    bool parsedFreeDelivery = false;
    if (rawFreeDelivery is bool) {
      parsedFreeDelivery = rawFreeDelivery;
    } else if (rawFreeDelivery != null) {
      final s = rawFreeDelivery.toString().toLowerCase();
      parsedFreeDelivery = s == '1' || s == 'true';
    }

    return PopularRestaurantItemModel(
      id: json['id'] ?? json['restaurant_id'],
      restaurantId: json['restaurant_id']?.toString(),
      name:
          (json['name']?.toString() ?? json['restaurant_name']?.toString() ?? '')
              .capitalizeWords(),
      image:
          json['image']?.toString() ??
          json['image_url']?.toString() ??
          json['banner']?.toString() ??
          json['logo']?.toString(),
      cuisine: computedCuisine?.capitalizeWords(),
      deliveryTime:
          (json['delivery_time']?.toString() ??
                  json['estimated_time']?.toString() ??
                  '25-30 mins')
              .capitalizeFirstLetter(),
      distance: computedDistance,
      distanceKm: parsedDistanceKm,
      openTime: openT,
      closeTime: closeT,
      openingTime: computedOpeningTime,
      isOpen: parsedIsOpen,
      freeDelivery: parsedFreeDelivery,
      rating: json['rating'] ?? json['avg_rating'],
      address: (json['address']?.toString() ?? json['location']?.toString())
          ?.capitalizeWords(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'name': name,
      'image': image,
      'cuisine': cuisine,
      'delivery_time': deliveryTime,
      'distance': distance,
      'distance_km': distanceKm,
      'open_time': openTime,
      'close_time': closeTime,
      'opening_time': openingTime,
      'is_open': isOpen,
      'free_delivery': freeDelivery,
      'rating': rating,
      'address': address,
    };
  }
}
