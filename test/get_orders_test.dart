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
      expect(first.productName, 'Pine Apple Juice');
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

    test('Filters out incomplete, draft, initiated, failed, and unpaid orders', () {
      final jsonResponse = {
        "success": true,
        "data": {
          "orders": [
            {
              "order_id": "1",
              "product_name": "Valid Order 1",
              "total_amount": 100,
              "status": "PENDING"
            },
            {
              "order_id": "2",
              "product_name": "Incomplete Order",
              "total_amount": 200,
              "status": "INCOMPLETE"
            },
            {
              "order_id": "3",
              "product_name": "Initiated Order",
              "total_amount": 300,
              "status": "INITIATED"
            },
            {
              "order_id": "4",
              "product_name": "Draft Order",
              "total_amount": 400,
              "status": "DRAFT"
            },
            {
              "order_id": "5",
              "product_name": "Payment Pending Order",
              "total_amount": 500,
              "status": "PAYMENT_PENDING"
            },
            {
              "order_id": "6",
              "product_name": "Failed Order",
              "total_amount": 600,
              "status": "FAILED"
            },
            {
              "order_id": "7",
              "product_name": "Unpaid Order",
              "total_amount": 700,
              "status": "UNPAID"
            },
            {
              "order_id": "8",
              "product_name": "Payment Failed Order",
              "total_amount": 800,
              "status": "PENDING",
              "payment_status": "failed"
            },
            {
              "order_id": "9",
              "product_name": "Incomplete Flag Order",
              "total_amount": 900,
              "status": "PENDING",
              "is_completed": false
            },
            {
              "order_id": "",
              "product_name": "Empty ID Order",
              "total_amount": 100,
              "status": "PENDING"
            },
            {
              "order_id": "10",
              "product_name": "Valid Delivered Order",
              "total_amount": 250,
              "status": "DELIVERED"
            }
          ]
        },
        "message": "Orders fetched successfully",
        "code": 200
      };

      final response = GetOrdersResponseModel.fromJson(jsonResponse);

      expect(response.orders.length, 2);
      expect(response.orders[0].orderId, '1');
      expect(response.orders[0].productName, 'Valid Order 1');
      expect(response.orders[1].orderId, '10');
      expect(response.orders[1].productName, 'Valid Delivered Order');
    });
  });
}
