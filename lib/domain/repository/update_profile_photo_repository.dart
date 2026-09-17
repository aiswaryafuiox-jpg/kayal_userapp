import 'package:kayal_userapp/data/model/update_profile_photo_response_model.dart';

abstract class UpdateProfilePhotoRepository {
  Future<UpdateProfilePhotoResponseModel> updateProfilePhoto({
    required dynamic imageFile,
  });
}
