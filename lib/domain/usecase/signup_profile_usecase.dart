import 'package:kayal_userapp/data/model/signup_profile_response_model.dart';
import 'package:kayal_userapp/domain/repository/signup_profile_repository.dart';

class SignupProfileUseCase {
  final SignupProfileRepository _repository;

  SignupProfileUseCase(this._repository);

  Future<SignupProfileResponseModel> call({
    required String fullName,
    required String email,
  }) async {
    return await _repository.signupProfile(
      fullName: fullName,
      email: email,
    );
  }
}
