import 'package:flutter_test/flutter_test.dart';
import 'package:kayal_userapp/data/model/update_profile_response_model.dart';

void main() {
  group('UpdateProfileResponseModel Test', () {
    test('Correctly parses update_profile API success response', () {
      final jsonResponse = {
        "success": true,
        "data": {
          "full_name": "Lunaa",
          "phone": "7685342317",
          "email": "lunaa@gmail.com",
          "address": "gsgdvewd",
          "location_type": null
        },
        "message": "Profile updated successfully",
        "code": 200
      };

      final response = UpdateProfileResponseModel.fromJson(jsonResponse);

      expect(response.success, isTrue);
      expect(response.message, 'Profile updated successfully');
      expect(response.code, 200);
      expect(response.data, isNotNull);

      final data = response.data!;
      expect(data.fullName, 'Lunaa');
      expect(data.phone, '7685342317');
      expect(data.email, 'lunaa@gmail.com');
      expect(data.address, 'gsgdvewd');
      expect(data.locationType, isNull);
    });

    test('Correctly handles error response', () {
      final jsonResponse = {
        "success": false,
        "message": "Validation failed",
        "errors": {
          "email": ["The email has already been taken."]
        },
        "code": 422
      };

      final response = UpdateProfileResponseModel.fromJson(jsonResponse);

      expect(response.success, isFalse);
      expect(response.message, 'Validation failed');
      expect(response.code, 422);
      expect(response.data, isNull);
      expect(response.formattedErrorMessage, 'The email has already been taken.');
    });
  });
}
