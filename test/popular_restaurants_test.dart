import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayal_userapp/data/model/popular_restaurants_response_model.dart';

void main() {
  test('PopularRestaurantsResponseModel parses API response correctly', () {
    const rawJson = '''
    {
      "success": true,
      "message": "No restaurants found within 60 km. Showing all restaurants by rating.",
      "selected_category": "pizza",
      "restaurants": {
        "within_20_km": [],
        "within_40_km": [],
        "within_60_km": [],
        "all_restaurants": [
          {
            "id": 2,
            "restaurant_id": "RST0002",
            "name": "faghja",
            "rating": 0,
            "distance_km": null,
            "image": "http://64.227.170.206/kayal.com/public/storage/restaurant_images/8WVsi4trcFw0XVMq4Y4w7Uvd7PrGdbGteXKjjM4V.jpg",
            "open_time": "03:09 PM",
            "close_time": "03:09 PM",
            "is_open": true,
            "free_delivery": false,
            "delivery_time": null
          }
        ]
      }
    }
    ''';

    final model = PopularRestaurantsResponseModel.fromJson(
      jsonDecode(rawJson) as Map<String, dynamic>,
    );

    expect(model.success, isTrue);
    expect(model.selectedCategory, 'pizza');
    expect(model.allRestaurants.length, 1);
    expect(model.data.length, 1);

    final restaurant = model.data.first;
    expect(restaurant.id, 2);
    expect(restaurant.restaurantId, 'RST0002');
    expect(restaurant.name, 'faghja');
    expect(restaurant.isOpen, isTrue);
    expect(restaurant.freeDelivery, isFalse);
    expect(restaurant.openingTime, '03:09 PM - 03:09 PM');
    expect(restaurant.cuisine, 'pizza Special');
    expect(restaurant.image, contains('8WVsi4trcFw0XVMq4Y4w7Uvd7PrGdbGteXKjjM4V.jpg'));
  });
}
