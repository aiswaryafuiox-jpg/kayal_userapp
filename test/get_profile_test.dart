import 'package:flutter_test/flutter_test.dart';
import 'package:kayal_userapp/data/model/get_profile_response_model.dart';

void main() {
  group('GetProfileResponseModel Test', () {
    test('Correctly parses get_profile API response with exact backend payload', () {
      final jsonResponse = {
        "success": true,
        "data": {
          "full_name": "John Doe",
          "phone": "7685342317",
          "email": "john@example.com",
          "profile_image": null,
          "default_address": {
            "text": "123, Barathi Street, T. Nagar",
            "location_type": "Home"
          }
        },
        "message": "Profile details fetched successfully.",
        "code": 200
      };

      final response = GetProfileResponseModel.fromJson(jsonResponse);

      expect(response.success, isTrue);
      expect(response.message, 'Profile details fetched successfully.');
      expect(response.code, 200);
      expect(response.data, isNotNull);

      final data = response.data!;
      expect(data.fullName, 'John Doe');
      expect(data.displayName, 'John Doe');
      expect(data.phone, '7685342317');
      expect(data.displayPhone, '7685342317');
      expect(data.email, 'john@example.com');
      expect(data.profileImage, isNull);
      expect(data.hasAvatar, isFalse);

      expect(data.defaultAddress, isNotNull);
      expect(data.defaultAddress!.text, '123, Barathi Street, T. Nagar');
      expect(data.defaultAddress!.locationType, 'Home');
    });

    test('Correctly parses response with network profile image URL', () {
      final jsonResponse = {
        "success": true,
        "data": {
          "full_name": "Jane Smith",
          "phone": "9876543210",
          "email": "jane@example.com",
          "profile_image": "http://64.227.170.206/kayal.com/public/storage/profiles/avatar.jpg",
          "default_address": {
            "text": "456, Lake View Road",
            "location_type": "Work"
          }
        },
        "message": "Profile details fetched successfully.",
        "code": 200
      };

      final response = GetProfileResponseModel.fromJson(jsonResponse);

      expect(response.success, isTrue);
      expect(response.data, isNotNull);

      final data = response.data!;
      expect(data.fullName, 'Jane Smith');
      expect(data.profileImage, "http://64.227.170.206/kayal.com/public/storage/profiles/avatar.jpg");
      expect(data.hasAvatar, isTrue);
      expect(data.defaultAddress?.locationType, 'Work');
    });

    test('Correctly handles error responses', () {
      final jsonResponse = {
        "success": false,
        "message": "Unauthenticated.",
        "code": 401
      };

      final response = GetProfileResponseModel.fromJson(jsonResponse);

      expect(response.success, isFalse);
      expect(response.message, 'Unauthenticated.');
      expect(response.code, 401);
      expect(response.data, isNull);
      expect(response.formattedErrorMessage, 'Unauthenticated.');
    });
  });
}
