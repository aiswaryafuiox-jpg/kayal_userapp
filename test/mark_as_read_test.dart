import 'package:flutter_test/flutter_test.dart';
import 'package:kayal_userapp/data/model/mark_as_read_response_model.dart';

void main() {
  group('MarkAsReadResponseModel Test', () {
    test('Correctly parses mark_as_read API success response', () {
      final jsonResponse = {
        "success": true,
        "message": "Notification marked as read",
        "data": null,
        "code": 200
      };

      final response = MarkAsReadResponseModel.fromJson(jsonResponse);

      expect(response.success, isTrue);
      expect(response.message, 'Notification marked as read');
      expect(response.code, 200);
      expect(response.data, isNull);
    });

    test('Correctly handles not found response', () {
      final jsonResponse = {
        "success": false,
        "message": "Notification not found",
        "errors": [],
        "code": 404
      };

      final response = MarkAsReadResponseModel.fromJson(jsonResponse);

      expect(response.success, isFalse);
      expect(response.message, 'Notification not found');
      expect(response.code, 404);
      expect(response.formattedErrorMessage, 'Notification not found');
    });
  });
}
