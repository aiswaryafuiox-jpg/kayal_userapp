import 'package:flutter_test/flutter_test.dart';
import 'package:kayal_userapp/data/model/get_notifications_response_model.dart';

void main() {
  group('GetNotificationsResponseModel Test', () {
    test('Correctly parses empty notifications list response', () {
      final jsonResponse = {
        "success": true,
        "data": {
          "notifications": [],
          "current_page": 1,
          "last_page": 1,
          "total": 0
        },
        "message": "Notifications fetched successfully",
        "code": 200
      };

      final response = GetNotificationsResponseModel.fromJson(jsonResponse);

      expect(response.success, isTrue);
      expect(response.message, 'Notifications fetched successfully');
      expect(response.code, 200);
      expect(response.data, isNotNull);
      expect(response.notifications, isEmpty);
      expect(response.data!.currentPage, 1);
      expect(response.data!.total, 0);
    });

    test('Correctly parses notification items with offer and order types', () {
      final jsonResponse = {
        "success": true,
        "data": {
          "notifications": [
            {
              "id": "1",
              "title": "Special Offer 20% OFF",
              "description": "Get 20% off on your favorite dishes today!",
              "time": "10 mins ago",
              "type": "offer",
              "image_url": "http://64.227.170.206/kayal.com/public/storage/offers/banner.png",
              "is_read": false
            },
            {
              "id": "2",
              "title": "Order Delivered",
              "description": "Your order #1024 has been delivered successfully.",
              "time": "1 hour ago",
              "type": "order",
              "image_url": null,
              "is_read": true
            }
          ],
          "current_page": 1,
          "last_page": 1,
          "total": 2
        },
        "message": "Notifications fetched successfully",
        "code": 200
      };

      final response = GetNotificationsResponseModel.fromJson(jsonResponse);

      expect(response.success, isTrue);
      expect(response.notifications.length, 2);

      final item1 = response.notifications[0];
      expect(item1.id, '1');
      expect(item1.title, 'Special Offer 20% OFF');
      expect(item1.isOffer, isTrue);
      expect(item1.imageUrl, 'http://64.227.170.206/kayal.com/public/storage/offers/banner.png');
      expect(item1.isRead, isFalse);

      final item2 = response.notifications[1];
      expect(item2.id, '2');
      expect(item2.title, 'Order Delivered');
      expect(item2.isOrder, isTrue);
      expect(item2.isRead, isTrue);
    });

    test('Correctly handles error response', () {
      final jsonResponse = {
        "success": false,
        "message": "Unauthenticated",
        "code": 401
      };

      final response = GetNotificationsResponseModel.fromJson(jsonResponse);

      expect(response.success, isFalse);
      expect(response.message, 'Unauthenticated');
      expect(response.code, 401);
      expect(response.notifications, isEmpty);
      expect(response.formattedErrorMessage, 'Unauthenticated');
    });
  });
}
