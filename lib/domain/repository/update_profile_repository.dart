import 'package:kayal_userapp/data/model/update_profile_response_model.dart';

abstract class UpdateProfileRepository {
  Future<UpdateProfileResponseModel> updateProfile({
    required String fullName,
    required String email,
    // String? address,
    // String? locationType,
    dynamic profileImageFile,
  });
}
