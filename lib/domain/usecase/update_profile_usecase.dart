import 'package:kayal_userapp/data/model/update_profile_response_model.dart';
import 'package:kayal_userapp/domain/repository/update_profile_repository.dart';

class UpdateProfileUseCase {
  final UpdateProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<UpdateProfileResponseModel> call({
    required String fullName,
    required String email,
    dynamic profileImageFile,
  }) {
    return _repository.updateProfile(
      fullName: fullName,
      email: email,
    
      profileImageFile: profileImageFile,
    );
  }
}
