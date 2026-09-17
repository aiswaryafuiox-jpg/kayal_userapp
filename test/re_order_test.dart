import 'package:flutter_test/flutter_test.dart';
import 'package:kayal_userapp/data/model/re_order_response_model.dart';

void main() {
  group('ReOrderResponseModel Test', () {
    test('Correctly parses re_order API success response', () {
      final jsonResponse = {
        "success": true,
        "data": {
          "cart_id": "1",
        },
        "message": "Items added to cart successfully",
        "code": 200,
      };

      final response = ReOrderResponseModel.fromJson(jsonResponse);

      expect(response.success, isTrue);
      expect(response.message, 'Items added to cart successfully');
      expect(response.code, 200);
      expect(response.data, isNotNull);
      expect(response.cartId, '1');
      expect(response.data!.cartId, '1');
    });

    test('Correctly handles failure or validation error responses', () {
      final errorResponse = {
        "success": false,
        "message": "Order not found or items unavailable",
        "code": 404,
      };

      final response = ReOrderResponseModel.fromJson(errorResponse);

      expect(response.success, isFalse);
      expect(response.message, 'Order not found or items unavailable');
      expect(response.code, 404);
      expect(response.data, isNull);
      expect(response.formattedErrorMessage, 'Order not found or items unavailable');
    });
  });
}
