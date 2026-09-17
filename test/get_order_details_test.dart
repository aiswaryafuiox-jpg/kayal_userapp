import 'package:flutter_test/flutter_test.dart';
import 'package:kayal_userapp/data/model/get_order_details_response_model.dart';

void main() {
  group('GetOrderDetailsResponseModel Test', () {
    test('Correctly parses get_order_details API response', () {
      final jsonResponse = {
        "success": true,
        "data": {
          "order_id": "2",
          "custom_order_id": "OID002",
          "order_date": "Sep 16, 2026 06:17 AM",
          "items": [
            {
              "product_id": 1,
              "name": "pine apple juice",
              "food_type": "non-veg",
              "image_url": "http://64.227.170.206/kayal.com/public/storage/products/saCqMXDpcvt297MAaOoEUbW7Iqh6omtr66ZhjXek.jpg",
              "qty": 2,
              "mrp": 200,
              "sell_price": 180
            }
          ],
          "delivery_address": {
            "id": "1",
            "address_type": "Home",
            "house_no": "",
            "street": "",
            "landmark": "Near Lake Park",
            "full_address": "123, Barathi Street, T. Nagar",
            "phone": "9876543210"
          },
          "summary": {
            "item_total": 400,
            "discount": 40,
            "grand_total": 360,
            "total_paid": 0
          },
          "payment_details": {
            "method": "cash_on_delivery",
            "status": "pending"
          }
        },
        "message": "Order details fetched successfully",
        "code": 200
      };

      final response = GetOrderDetailsResponseModel.fromJson(jsonResponse);

      expect(response.success, isTrue);
      expect(response.message, 'Order details fetched successfully');
      expect(response.code, 200);
      expect(response.data, isNotNull);

      final data = response.data!;
      expect(data.orderId, '2');
      expect(data.customOrderId, 'OID002');
      expect(data.orderDate, 'Sep 16, 2026 06:17 AM');
      expect(data.items.length, 1);

      final item = data.items.first;
      expect(item.productId, 1);
      expect(item.name, 'pine apple juice');
      expect(item.foodType, 'Non-Veg');
      expect(item.isVeg, isFalse);
      expect(item.qty, 2);
      expect(item.mrp, 200.0);
      expect(item.sellPrice, 180.0);

      expect(data.deliveryAddress, isNotNull);
      expect(data.deliveryAddress!.fullAddress, '123, Barathi Street, T. Nagar');
      expect(data.deliveryAddress!.phone, '9876543210');

      expect(data.summary, isNotNull);
      expect(data.summary!.itemTotal, 400.0);
      expect(data.summary!.discount, 40.0);
      expect(data.summary!.grandTotal, 360.0);

      expect(data.paymentDetails, isNotNull);
      expect(data.paymentDetails!.method, 'cash_on_delivery');
      expect(data.paymentDetails!.displayMethod, 'Cash on delivery');
      expect(data.paymentDetails!.displayStatus, 'Pending');
    });
  });
}
