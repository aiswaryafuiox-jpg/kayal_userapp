import 'package:flutter_test/flutter_test.dart';
import 'package:kayal_userapp/data/model/delete_notification_response_model.dart';

void main() {
  group('DeleteNotificationResponseModel Test', () {
    test('Correctly parses delete_notification API success response', () {
      final jsonResponse = {
        "success": true,
        "message": "Notification deleted successfully",
        "data": null,
        "code": 200
      };

      final response = DeleteNotificationResponseModel.fromJson(jsonResponse);

      expect(response.success, isTrue);
      expect(response.message, 'Notification deleted successfully');
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

      final response = DeleteNotificationResponseModel.fromJson(jsonResponse);

      expect(response.success, isFalse);
      expect(response.message, 'Notification not found');
      expect(response.code, 404);
      expect(response.formattedErrorMessage, 'Notification not found');
    });
  });
}
