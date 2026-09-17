import 'package:flutter_test/flutter_test.dart';
import 'package:kayal_userapp/data/model/get_terms_response_model.dart';

void main() {
  group('GetTermsResponseModel Test', () {
    test('Correctly parses terms with object payload', () {
      final jsonResponse = {
        "success": true,
        "data": {
          "id": "1",
          "title": "Kayal User Terms & Conditions",
          "content": "Please read these terms carefully before placing orders.",
          "type": "user",
          "updated_at": "2026-09-16"
        },
        "message": "Terms fetched successfully",
        "code": 200
      };

      final response = GetTermsResponseModel.fromJson(jsonResponse);

      expect(response.success, isTrue);
      expect(response.message, 'Terms fetched successfully');
      expect(response.code, 200);
      expect(response.data, isNotNull);
      expect(response.title, 'Kayal User Terms & Conditions');
      expect(response.content, 'Please read these terms carefully before placing orders.');
      expect(response.data!.hasContent, isTrue);
    });

    test('Correctly parses terms with direct string payload', () {
      final jsonResponse = {
        "success": true,
        "data": "1. All sales are final.\n2. Delivery within 30-45 mins.",
        "message": "Terms fetched successfully",
        "code": 200
      };

      final response = GetTermsResponseModel.fromJson(jsonResponse);

      expect(response.success, isTrue);
      expect(response.content, "1. All sales are final.\n2. Delivery within 30-45 mins.");
      expect(response.data!.displayTitle, 'Terms & Conditions');
    });

    test('Correctly handles 404 not configured error response', () {
      final jsonResponse = {
        "success": false,
        "message": "Terms and conditions for 'user' not found",
        "errors": [],
        "code": 404
      };

      final response = GetTermsResponseModel.fromJson(jsonResponse);

      expect(response.success, isFalse);
      expect(response.message, "Terms and conditions for 'user' not found");
      expect(response.code, 404);
      expect(response.data, isNull);
      expect(response.formattedErrorMessage, "Terms and conditions for 'user' not found");
    });
  });
}
