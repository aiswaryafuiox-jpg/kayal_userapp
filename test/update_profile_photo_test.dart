import 'package:flutter_test/flutter_test.dart';
import 'package:kayal_userapp/data/model/update_profile_photo_response_model.dart';

void main() {
  group('UpdateProfilePhotoResponseModel Test', () {
    test('Correctly parses update_profile_photo API success response', () {
      final jsonResponse = {
        "success": true,
        "data": {
          "photo_url": "http://64.227.170.206/kayal.com/public/storage/customer/profiles/j5AVnagZu06yXSRc3Gh0xpZ7BbY0GlXRHefbYT82.png"
        },
        "message": "Photo updated",
        "code": 200
      };

      final response = UpdateProfilePhotoResponseModel.fromJson(jsonResponse);

      expect(response.success, isTrue);
      expect(response.message, 'Photo updated');
      expect(response.code, 200);
      expect(response.data, isNotNull);
      expect(response.photoUrl, "http://64.227.170.206/kayal.com/public/storage/customer/profiles/j5AVnagZu06yXSRc3Gh0xpZ7BbY0GlXRHefbYT82.png");
      expect(response.data!.photoUrl, "http://64.227.170.206/kayal.com/public/storage/customer/profiles/j5AVnagZu06yXSRc3Gh0xpZ7BbY0GlXRHefbYT82.png");
    });

    test('Correctly handles failure responses', () {
      final jsonResponse = {
        "success": false,
        "message": "The image file must be an image.",
        "errors": {
          "image_file": ["The image file must be an image."]
        },
        "code": 422
      };

      final response = UpdateProfilePhotoResponseModel.fromJson(jsonResponse);

      expect(response.success, isFalse);
      expect(response.message, 'The image file must be an image.');
      expect(response.code, 422);
      expect(response.data, isNull);
      expect(response.photoUrl, '');
      expect(response.formattedErrorMessage, 'The image file must be an image.');
    });
  });
}
