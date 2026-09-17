import 'package:flutter_test/flutter_test.dart';
import 'package:kayal_userapp/data/model/get_orders_response_model.dart';

void main() {
  group('GetOrdersResponseModel Test', () {
    test('Correctly parses get_orders API response', () {
      final jsonResponse = {
        "success": true,
        "data": {
          "orders": [
            {
              "order_id": "15",
              "product_name": "pine apple juice",
              "food_type": 0,
              "date": "Sep 16, 2026, 09:55 AM",
              "total_amount": 180,
              "status": "PENDING",
              "image_url": "http://64.227.170.206/kayal.com/public/storage/products/saCqMXDpcvt297MAaOoEUbW7Iqh6omtr66ZhjXek.jpg"
            },
            {
              "order_id": "5",
              "product_name": "pine apple juice",
              "food_type": 0,
              "date": "Sep 16, 2026, 06:18 AM",
              "total_amount": 360,
              "status": "FOOD_READY",
              "image_url": "http://64.227.170.206/kayal.com/public/storage/products/saCqMXDpcvt297MAaOoEUbW7Iqh6omtr66ZhjXek.jpg"
            }
          ],
          "current_page": 1,
          "last_page": 1,
          "total": 2
        },
        "message": "Orders fetched successfully",
        "code": 200
      };

      final response = GetOrdersResponseModel.fromJson(jsonResponse);

      expect(response.success, isTrue);
      expect(response.message, 'Orders fetched successfully');
      expect(response.code, 200);
      expect(response.data, isNotNull);
      expect(response.orders.length, 2);

      final first = response.orders.first;
      expect(first.orderId, '15');
      expect(first.productName, 'pine apple juice');
      expect(first.totalAmount, 180.0);
      expect(first.rawStatus, 'PENDING');
      expect(first.displayStatus, 'Pending');
      expect(first.isTrackable, isTrue);
      expect(first.isDelivered, isFalse);
      expect(first.imageUrl, contains('saCqMXDpcvt297MAaOoEUbW7Iqh6omtr66ZhjXek.jpg'));

      final second = response.orders[1];
      expect(second.orderId, '5');
      expect(second.totalAmount, 360.0);
      expect(second.displayStatus, 'Food Ready');
    });
  });
}
