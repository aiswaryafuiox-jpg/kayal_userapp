import 'package:flutter_test/flutter_test.dart';
import 'package:kayal_userapp/data/model/get_privacy_policy_response_model.dart';

void main() {
  group('GetPrivacyPolicyResponseModel Test', () {
    test('Correctly parses privacy policy with object payload', () {
      final jsonResponse = {
        "success": true,
        "data": {
          "id": "1",
          "title": "Kayal User Privacy Policy",
          "content": "We value your privacy and protect your personal information.",
          "type": "user",
          "updated_at": "2026-09-16"
        },
        "message": "Privacy policy fetched successfully",
        "code": 200
      };

      final response = GetPrivacyPolicyResponseModel.fromJson(jsonResponse);

      expect(response.success, isTrue);
      expect(response.message, 'Privacy policy fetched successfully');
      expect(response.code, 200);
      expect(response.data, isNotNull);
      expect(response.title, 'Kayal User Privacy Policy');
      expect(response.content, 'We value your privacy and protect your personal information.');
      expect(response.data!.hasContent, isTrue);
    });

    test('Correctly parses privacy policy with direct string payload', () {
      final jsonResponse = {
        "success": true,
        "data": "1. We do not sell your personal data.\n2. Location is only used for deliveries.",
        "message": "Privacy policy fetched successfully",
        "code": 200
      };

      final response = GetPrivacyPolicyResponseModel.fromJson(jsonResponse);

      expect(response.success, isTrue);
      expect(response.content, "1. We do not sell your personal data.\n2. Location is only used for deliveries.");
      expect(response.data!.displayTitle, 'Privacy Policy');
    });

    test('Correctly handles 404 not configured error response', () {
      final jsonResponse = {
        "success": false,
        "message": "Privacy policy for 'user' not found",
        "errors": [],
        "code": 404
      };

      final response = GetPrivacyPolicyResponseModel.fromJson(jsonResponse);

      expect(response.success, isFalse);
      expect(response.message, "Privacy policy for 'user' not found");
      expect(response.code, 404);
      expect(response.data, isNull);
      expect(response.formattedErrorMessage, "Privacy policy for 'user' not found");
    });
  });
}
