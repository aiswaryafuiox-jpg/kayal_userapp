import 'package:kayal_userapp/data/model/signup_response_model.dart';
import 'package:kayal_userapp/domain/repository/signup_repository.dart';

class SignupUseCase {
  final SignupRepository _repository;

  SignupUseCase(this._repository);

  Future<SignupResponseModel> call({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
  }) async {
    return await _repository.signup(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      email: email,
    );
  }
}
