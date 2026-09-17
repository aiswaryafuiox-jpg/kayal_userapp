import 'package:kayal_userapp/data/model/update_profile_photo_response_model.dart';
import 'package:kayal_userapp/domain/repository/update_profile_photo_repository.dart';

class UpdateProfilePhotoUseCase {
  final UpdateProfilePhotoRepository _repository;

  UpdateProfilePhotoUseCase(this._repository);

  Future<UpdateProfilePhotoResponseModel> call({required dynamic imageFile}) {
    return _repository.updateProfilePhoto(imageFile: imageFile);
  }
}
