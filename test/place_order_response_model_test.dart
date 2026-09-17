import 'package:flutter_test/flutter_test.dart';
import 'package:kayal_userapp/data/model/place_order_response_model.dart';

void main() {
  group('PlaceOrderResponseModel Test', () {
    test('Correctly parses exact Postman place order response', () {
      final jsonResponse = {
        "success": true,
        "data": {
          "order_id": "14",
          "custom_order_id": "OID006",
          "total_amount": 180,
          "payment_status": "pending",
          "estimated_delivery": "25 - 35 Minutes",
          "status": "success"
        },
        "message": "Order placed successfully",
        "code": 201
      };

      final response = PlaceOrderResponseModel.fromJson(jsonResponse);

      expect(response.success, isTrue);
      expect(response.message, 'Order placed successfully');
      expect(response.code, 201);
      expect(response.data, isNotNull);
      expect(response.data?.orderId, '14');
      expect(response.data?.customOrderId, 'OID006');
      expect(response.data?.totalAmount, 180.0);
      expect(response.data?.paymentStatus, 'pending');
      expect(response.data?.estimatedDelivery, '25 - 35 Minutes');
      expect(response.data?.status, 'success');

      // Convenience getters
      expect(response.orderId, '14');
      expect(response.customOrderId, 'OID006');
      expect(response.orderNumber, 'OID006');
      expect(response.totalAmount, 180.0);
      expect(response.estimatedDelivery, '25 - 35 Minutes');
      expect(response.paymentStatus, 'pending');
      expect(response.status, 'success');
    });
  });
}
